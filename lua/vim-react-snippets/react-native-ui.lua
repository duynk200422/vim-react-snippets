local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- rv -> <View></View>
  s("rv", {
    t({ "<View>", "\t" }),
    i(0),
    t({ "", "</View>" }),
  }),

  -- rt -> <Text></Text>
  s("rt", {
    t("<Text>"),
    i(0),
    t("</Text>"),
  }),

  -- ri -> <Image source={...} />
  s("ri", {
    t('<Image source={{ uri: "'),
    i(1, "https://placehold.co/100"),
    t('" }} />'),
    i(0),
  }),

  -- rsv -> <ScrollView></ScrollView>
  s("rsv", {
    t({ "<ScrollView>", "\t" }),
    i(0),
    t({ "", "</ScrollView>" }),
  }),

  -- rfl -> <FlatList />
  s("rfl", {
    t({ "<FlatList" }),
    t({ '  data={'..i(1, 'DATA')..'}'}),
    t({ '  renderItem={({ item }) => ('}),
    t({ '    <View>'),
    t({ '      <Text>{item.title}</Text>'}),
    t({ '    </View>'}),
    t({ '  )}'}),
    t({ '  keyExtractor={item => item.id}'}),
    t({ '/>'}),
    i(0)
  }),

  -- rsl -> <SectionList />
  s("rsl", {
    t({ "<SectionList" }),
    t({ '  sections={'..i(1, 'SECTIONS')..'}'}),
    t({ '  renderItem={({ item }) => ('}),
    t({ '    <View>'),
    t({ '      <Text>{item}</Text>'}),
    t({ '    </View>'}),
    t({ '  )}'}),
    t({ '  renderSectionHeader={({ section: { title } }) => ('}),
    t({ '    <Text>{title}</Text>'}),
    t({ '  )}'}),
    t({ '  keyExtractor={(item, index) => item + index}'}),
    t({ '/>'}),
    i(0)
  }),

  -- rti -> <TextInput />
  s("rti", {
    t('<TextInput'),
    t({ '  style={'..i(1, 'styles.input')..'}'}),
    t({ '  onChangeText={'..i(2, 'setText')..'}'}),
    t({ '  value={'..i(3, 'text')..'}'}),
    t({ '  placeholder="'..i(4, 'Type here...')..'" '}),
    t('/>'),
    i(0)
  }),

  -- rp -> <Pressable></Pressable>
  s("rp", {
    t({ "<Pressable>", "\t" }),
    i(0),
    t({ "", "</Pressable>" }),
  }),

  -- rto -> <TouchableOpacity></TouchableOpacity>
  s("rto", {
    t({ "<TouchableOpacity>", "\t" }),
    i(0),
    t({ "", "</TouchableOpacity>" }),
  }),

  -- rth -> <TouchableHighlight></TouchableHighlight>
  s("rth", {
    t({ "<TouchableHighlight>", "\t" }),
    i(0),
    t({ "", "</TouchableHighlight>" }),
  }),

  -- rb -> <Button />
  s("rb", {
    t('<Button title="'),
    i(1, "Press Me"),
    t('" onPress={() => {}} />'),
    i(0),
  }),

  -- rsw -> <Switch />
  s("rsw", {
    t('<Switch'),
    t({ '  trackColor={{ false: "#767577", true: "#81b0ff" }}' }),
    t({ '  thumbColor={'..i(1, 'isEnabled')..' ? "#f5dd4b" : "#f4f3f4"}' }),
    t({ '  onValueChange={'..i(2, 'toggleSwitch')..'}' }),
    t({ '  value={'..i(3, 'isEnabled')..'}' }),
    t('/>'),
    i(0),
  }),

  -- rsav -> <SafeAreaView></SafeAreaView>
  s("rsav", {
    t({ "<SafeAreaView>", "\t" }),
    i(0),
    t({ "", "</SafeAreaView>" }),
  }),

  -- rm -> <Modal></Modal>
  s("rm", {
    t({ '<Modal animationType="slide" transparent={true} visible={'..i(1, 'modalVisible')..'}>', "" }),
    t({ "\t<View>", "" }),
    t({ "\t\t", "" }),
    i(0),
    t({ "\t</View>", "" }),
    t({ "</Modal>", "" }),
  }),

  -- rsb -> <StatusBar />
  s("rsb", {
    t('<StatusBar barStyle="'),
    i(1, "dark-content"),
    t('" />'),
    i(0),
  }),

  -- rai -> <ActivityIndicator />
  s("rai", {
    t('<ActivityIndicator size="'),
    i(1, "large"),
    t('" color="'),
    i(2, "#0000ff"),
    t('" />'),
    i(0),
  }),

  -- rkav -> <KeyboardAvoidingView></KeyboardAvoidingView>
  s("rkav", {
    t('<KeyboardAvoidingView behavior={Platform.OS === "ios" ? "padding" : "height"}>'),
    i(0),
    t("</KeyboardAvoidingView>"),
  }),
}
