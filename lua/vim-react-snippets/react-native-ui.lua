local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
-- Assuming util.merge_lists is available from your config, with a fallback.
local util = require("vim-react-snippets.util")

---
-- Creates a snippet for a simple enclosing tag, e.g., <View></View>.
-- @param trigger string The snippet trigger.
-- @param tag_name string The name of the JSX tag.
-- @return Snippet
local function create_enclosing_snippet(trigger, tag_name)
  return s(trigger, {
    t("<" .. tag_name .. ">"),
    i(0), -- Cursor position inside the tag
    t("</" .. tag_name .. ">"),
  })
end

-- A list of simple components that just enclose content.
local simple_enclosing_tags = {
  { trig = "_rv", tag = "View" },
  { trig = "_rt", tag = "Text" },
  { trig = "_rsv", tag = "ScrollView" },
  { trig = "_rp", tag = "Pressable" },
  { trig = "_rto", tag = "TouchableOpacity" },
  { trig = "_rth", tag = "TouchableHighlight" },
  { trig = "_rsav", tag = "SafeAreaView" },
}

-- Generate the simple snippets programmatically.
local simple_snippets = {}
for _, tag_info in ipairs(simple_enclosing_tags) do
  table.insert(simple_snippets, create_enclosing_snippet(tag_info.trig, tag_info.tag))
end

-- A list of more complex snippets with unique properties and structures.
local complex_snippets = {
  -- _ri -> <Image source={...} />
  s("_ri", {
    t('<Image source={{ uri: "'),
    i(1, "https://placehold.co/100"),
    t('" }} />'),
    i(0),
  }),

  -- _rfl -> <FlatList />
  s("_rfl", {
    t({
      "<FlatList",
      "  data={",
    }),
    i(1, "DATA"),
    t({
      "}",
      "  renderItem={({ item }) => (",
      "    <View>",
      "      ",
    }),
    i(2, "<Text>{item.title}</Text>"),
    t({
      "",
      "    </View>",
      "  )}",
      "  keyExtractor={item => item.",
    }),
    i(3, "id"),
    t({
      "}",
      "/>",
    }),
    i(0),
  }),

  -- _rsl -> <SectionList />
  s("_rsl", {
    t({
      "<SectionList",
      "  sections={",
    }),
    i(1, "SECTIONS"),
    t({
      "}",
      "  renderItem={({ item, index }) => (",
      "    <View key={index}>",
      "      ",
    }),
    i(2, "<Text>{item}</Text>"),
    t({
      "",
      "    </View>",
      "  )}",
      "  renderSectionHeader={({ section: { title } }) => (",
      "    <Text>{title}</Text>",
      "  )}",
      "  keyExtractor={(item, index) => item + index}",
      "/>",
    }),
    i(0),
  }),

  -- _rti -> <TextInput />
  s("_rti", {
    t("<TextInput"),
    t({ "  style={" }),
    i(1, "styles.input"),
    t({ "}" }),
    t({ "  onChangeText={" }),
    i(2, "setText"),
    t({ "}" }),
    t({ "  value={" }),
    i(3, "text"),
    t({ "}" }),
    t({ '  placeholder="' }),
    i(4, "Type here..."),
    t({ '" ' }),
    t("/>"),
    i(0),
  }),

  -- _rb -> <Button />
  s("_rb", {
    t('<Button title="'),
    i(1, "Press Me"),
    t('" onPress={() => {}} />'),
    i(0),
  }),

  -- _rsw -> <Switch />
  s("_rsw", {
    t("<Switch"),
    t({ '  trackColor={{ false: "#767577", true: "#81b0ff" }}' }),
    t({ "  thumbColor={" }),
    i(1, "isEnabled"),
    t({ ' ? "#f5dd4b" : "#f4f3f4"}' }),
    t({ "  onValueChange={" }),
    i(2, "toggleSwitch"),
    t({ "}" }),
    t({ "  value={" }),
    i(3, "isEnabled"),
    t({ "}" }),
    t("/>"),
    i(0),
  }),

  -- _rm -> <Modal></Modal>
  s("_rm", {
    t('<Modal animationType="slide" transparent={true} visible={'),
    i(1, "modalVisible"),
    t({
      "}>",
      "  <View>",
      "    ",
    }),
    i(0),
    t({
      "",
      "  </View>",
      "</Modal>",
    }),
  }),

  -- _rsb -> <StatusBar />
  s("_rsb", {
    t('<StatusBar barStyle="'),
    i(1, "dark-content"),
    t('" />'),
    i(0),
  }),

  -- _rai -> <ActivityIndicator />
  s("_rai", {
    t('<ActivityIndicator size="'),
    i(1, "large"),
    t('" color="'),
    i(2, "#0000ff"),
    t('" />'),
    i(0),
  }),

  -- _rkav -> <KeyboardAvoidingView></KeyboardAvoidingView>
  s("_rkav", {
    t('<KeyboardAvoidingView behavior={Platform.OS === "ios" ? "padding" : "height"}>'),
    i(0),
    t("</KeyboardAvoidingView>"),
  }),
}

-- If util.merge_lists is available, use it. Otherwise, manually merge.
if util and util.merge_lists then
  return util.merge_lists(simple_snippets, complex_snippets)
else
  -- Manual fallback merge
  local all_snippets = {}
  for _, snip in ipairs(simple_snippets) do
    table.insert(all_snippets, snip)
  end
  for _, snip in ipairs(complex_snippets) do
    table.insert(all_snippets, snip)
  end
  return all_snippets
end
