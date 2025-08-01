-- ============================================================================
-- Fast Tag Snippets for React Native
--
-- This file provides two types of snippets for common components:
-- 1. Single Tag (e.g., _v -> View)
-- 2. Enclosing Tag (e.g., _rv -> <View></View>)
-- ============================================================================

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Merges multiple lists (tables) into one.
local function merge_lists(...)
  local result = {}
  for _, list in ipairs({ ... }) do
    for _, item in ipairs(list) do
      table.insert(result, item)
    end
  end
  return result
end

-- ============================================================================
-- Snippet Generator Functions
-- ============================================================================

--- Creates a snippet for just the component name, e.g., View.
--- @param trigger string The snippet trigger (e.g., "_v").
--- @param tag_name string The name of the component (e.g., "View").
local function create_single_tag_snippet(trigger, tag_name)
  return s(trigger, {
    t(tag_name),
  })
end

--- Creates a snippet for an enclosing tag, e.g., <View></View>.
--- @param trigger string The snippet trigger (e.g., "_rv").
--- @param tag_name string The name of the component (e.g., "View").
local function create_enclosing_snippet(trigger, tag_name)
  return s(trigger, {
    t("<" .. tag_name .. ">"),
    i(0), -- Cursor position inside the tag
    t("</" .. tag_name .. ">"),
  })
end

-- ============================================================================
-- Tag Definitions
-- ============================================================================

-- Define all the component tags you want here.
-- The script will automatically create both single and enclosing snippets.
local component_tags = {
  { single_trig = "_v", enclosing_trig = "_rv", tag = "View" },
  { single_trig = "_t", enclosing_trig = "_rt", tag = "Text" },
  { single_trig = "_sv", enclosing_trig = "_rsv", tag = "ScrollView" },
  { single_trig = "_p", enclosing_trig = "_rp", tag = "Pressable" },
  { single_trig = "_to", enclosing_trig = "_rto", tag = "TouchableOpacity" },
  { single_trig = "_th", enclosing_trig = "_rth", tag = "TouchableHighlight" },
  { single_trig = "_sav", enclosing_trig = "_rsav", tag = "SafeAreaView" },
  { single_trig = "_i", enclosing_trig = "_ri", tag = "Image" },
  { single_trig = "_fl", enclosing_trig = "_rfl", tag = "FlatList" },
  { single_trig = "_sl", enclosing_trig = "_rsl", tag = "SectionList" },
  { single_trig = "_ti", enclosing_trig = "_rti", tag = "TextInput" },
}

-- ============================================================================
-- Snippet Generation and Final Assembly
-- ============================================================================

local single_tag_snippets = {}
local enclosing_tag_snippets = {}

-- Programmatically create all the snippets based on the definitions above.
for _, tag_info in ipairs(component_tags) do
  table.insert(single_tag_snippets, create_single_tag_snippet(tag_info.single_trig, tag_info.tag))
  table.insert(enclosing_tag_snippets, create_enclosing_snippet(tag_info.enclosing_trig, tag_info.tag))
end

-- Return the final merged list of all generated snippets.
return merge_lists(single_tag_snippets, enclosing_tag_snippets)
