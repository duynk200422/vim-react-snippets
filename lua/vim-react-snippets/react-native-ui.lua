-- ============================================================================
-- Fast Tag Snippets for React Native
--
-- This file provides three types of snippets for common components:
-- 1. Single Tag Name (e.g., _v -> View)
-- 2. Enclosing Tag (e.g., _rv -> <View></View>)
-- 3. Self-Closing Tag (e.g., _ri -> <Image />)
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
local function create_single_tag_snippet(trigger, tag_name)
  return s(trigger, { t(tag_name) })
end

--- Creates a snippet for an enclosing tag, e.g., <View></View>.
local function create_enclosing_snippet(trigger, tag_name)
  return s(trigger, {
    t("<" .. tag_name .. ">"),
    i(0), -- Cursor position inside the tag
    t("</" .. tag_name .. ">"),
  })
end

--- Creates a snippet for a self-closing tag, e.g., <Image />.
local function create_self_closing_snippet(trigger, tag_name)
  return s(trigger, {
    t("<" .. tag_name .. " />"),
    i(0), -- Cursor position after the tag
  })
end

-- ============================================================================
-- Tag Definitions
-- ============================================================================

-- Define all component tags here.
-- type: 'enclosing' for tags like <View>...</View>
-- type: 'self-closing' for tags like <Image />
local component_tags = {
  -- Enclosing Tags
  { base_trig = "v", tag = "View", type = "enclosing" },
  { base_trig = "t", tag = "Text", type = "enclosing" },
  { base_trig = "sv", tag = "ScrollView", type = "enclosing" },
  { base_trig = "p", tag = "Pressable", type = "enclosing" },
  { base_trig = "to", tag = "TouchableOpacity", type = "enclosing" },
  { base_trig = "th", tag = "TouchableHighlight", type = "enclosing" },
  { base_trig = "sav", tag = "SafeAreaView", type = "enclosing" },
  { base_trig = "fl", tag = "FlatList", type = "enclosing" },
  { base_trig = "sl", tag = "SectionList", type = "enclosing" },
  { base_trig = "m", tag = "Modal", type = "enclosing" },
  { base_trig = "kav", tag = "KeyboardAvoidingView", type = "enclosing" },

  -- Self-Closing Tags
  { base_trig = "i", tag = "Image", type = "self-closing" },
  { base_trig = "ti", tag = "TextInput", type = "self-closing" },
  { base_trig = "b", tag = "Button", type = "self-closing" },
  { base_trig = "sb", tag = "StatusBar", type = "self-closing" },
  { base_trig = "ai", tag = "ActivityIndicator", type = "self-closing" },
}

-- ============================================================================
-- Snippet Generation and Final Assembly
-- ============================================================================

local all_snippets = {}

-- Programmatically create all the snippets based on the definitions above.
for _, tag_info in ipairs(component_tags) do
  local single_trigger = "_" .. tag_info.base_trig
  local rich_trigger = "_r" .. tag_info.base_trig

  -- 1. Create the single tag snippet (e.g., _v -> View)
  table.insert(all_snippets, create_single_tag_snippet(single_trigger, tag_info.tag))

  -- 2. Create the rich snippet based on type
  if tag_info.type == "enclosing" then
    table.insert(all_snippets, create_enclosing_snippet(rich_trigger, tag_info.tag))
  elseif tag_info.type == "self-closing" then
    table.insert(all_snippets, create_self_closing_snippet(rich_trigger, tag_info.tag))
  end
end

-- Return the final list of all generated snippets.
return all_snippets
