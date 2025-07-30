local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local util = require("vim-react-snippets.util") -- Assuming util is available for merge_lists

--- Creates a snippet for a simple enclosing tag, e.g., <View></View>.
--- @param trigger string The snippet trigger, e.g., "rv".
--- @param tag_name string The name of the HTML/JSX tag, e.g., "View".
--- @return Snippet
local function create_enclosing_snippet(trigger, tag_name)
  return s(trigger, {
    t("<" .. tag_name .. ">"),
    i(0),
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
  -- ri -> <Image source={...} />
  s("_ri", {
    t('<Image source={{ uri: "'),
    i(1, "https://placehold.co/100"),
    t('" }} />'),
    i(0),
  }),

  -- rfl -> <FlatList />
  s("_rfl", {
    t({ "<FlatList" }),
    t({ "  data={" .. i(1, "DATA") .. "}" }),
    t({ "  renderItem={({ item }) => (" }),
    t({ "    <View>" }),
    t({ "      <Text>{item.title}</Text>" }),
    t({ "    </View>" }),
    t({ "  )}" }),
    t({ "  keyExtractor={item => item.id}" }),
    t({ "/>" }),
    i(0),
  }),

  -- rsl -> <SectionList />
  s("_rsl", {
    t({ "<SectionList" }),
    t({ "  sections={" .. i(1, "SECTIONS") .. "}" }),
    t({ "  renderItem={({ item }) => (" }),
    t({ "    <View>" }),
    t({ "      <Text>{item}</Text>" }),
    t({ "    </View>" }),
    t({ "  )}" }),
    t({ "  renderSectionHeader={({ section: { title } }) => (" }),
    t({ "    <Text>{title}</Text>" }),
    t({ "  )}" }),
    t({ "  keyExtractor={(item, index) => item + index}" }),
    t({ "/>" }),
    i(0),
  }),

  -- rti -> <TextInput />
  s("_rti", {
    t("<TextInput"),
    t({ "  style={" .. i(1, "styles.input") .. "}" }),
    t({ "  onChangeText={" .. i(2, "setText") .. "}" }),
    t({ "  value={" .. i(3, "text") .. "}" }),
    t({ '  placeholder="' .. i(4, "Type here...") .. '" ' }),
    t("/>"),
    i(0),
  }),

  -- rb -> <Button />
  s("_rb", {
    t('<Button title="'),
    i(1, "Press Me"),
    t('" onPress={() => {}} />'),
    i(0),
  }),

  -- rsw -> <Switch />
  s("_rsw", {
    t("<Switch"),
    t({ '  trackColor={{ false: "#767577", true: "#81b0ff" }}' }),
    t({ "  thumbColor={" .. i(1, "isEnabled") .. ' ? "#f5dd4b" : "#f4f3f4"}' }),
    t({ "  onValueChange={" .. i(2, "toggleSwitch") .. "}" }),
    t({ "  value={" .. i(3, "isEnabled") .. "}" }),
    t("/>"),
    i(0),
  }),

  -- rm -> <Modal></Modal>
  s("_rm", {
    t({ '<Modal animationType="slide" transparent={true} visible={' .. i(1, "modalVisible") .. "}>", "" }),
    t({ "\t<View>", "" }),
    t({ "\t\t", "" }),
    i(0),
    t({ "", "\t</View>" }),
    t({ "", "</Modal>" }),
  }),

  -- rsb -> <StatusBar />
  s("_rsb", {
    t('<StatusBar barStyle="'),
    i(1, "dark-content"),
    t('" />'),
    i(0),
  }),

  -- rai -> <ActivityIndicator />
  s("_rai", {
    t('<ActivityIndicator size="'),
    i(1, "large"),
    t('" color="'),
    i(2, "#0000ff"),
    t('" />'),
    i(0),
  }),

  -- rkav -> <KeyboardAvoidingView></KeyboardAvoidingView>
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
