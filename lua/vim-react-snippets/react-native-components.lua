local util = require("vim-react-snippets.util")
local config = require("vim-react-snippets.config")

local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Fallback function in case 'util.get_filename' is not defined in your setup.
-- In a real config, this would extract the current buffer's filename without extension.
if not util.get_filename then
  util.get_filename = function()
    return "Component"
  end
end

--- @private
--- @class ReactNativeComponentOptions
--- @field props boolean
--- @field export boolean | "default"
--- @field forward boolean
--- @field typescript boolean

--- Combines imports from 'react' and 'react-native'.
--- @param opts ReactNativeComponentOptions
local all_imports = function(opts)
  local rn_imports = { "StyleSheet", "View" }
  local react_parts = {}

  if opts.forward then
    table.insert(react_parts, "forwardRef")
  end

  if opts.typescript then
    table.insert(rn_imports, "Text") -- A sensible default for placeholders
    table.insert(react_parts, "type ReactElement")
    if opts.props or opts.forward then
      table.insert(react_parts, "type ReactNode")
    end
  end

  local react_import_str = ""
  if #react_parts > 0 then
    react_import_str = "import { " .. table.concat(react_parts, ", ") .. ' } from "react"'
  end

  return {
    t({
      'import React from "react"',
      "import { " .. table.concat(rn_imports, ", ") .. ' } from "react-native"',
      react_import_str,
      "",
    }),
  }
end

--- Generates the TypeScript 'Props' interface.
--- @param opts ReactNativeComponentOptions
local component_props = function(opts)
  if not opts.typescript or (not opts.props and not opts.forward) then
    return {}
  end

  local export = opts.export ~= false

  return {
    t((export and "export " or "") .. "interface "),
    f(function(nodes)
      return nodes[1] .. "Props"
    end, { 1 }), -- Mirrors i(1) and appends "Props"
    t({ " {", "\t" }),
    i(2, "-- your props here"),
    t({ "", "\tchildren?: ReactNode", "}", "", "" }),
  }
end

--- Generates the component function signature.
--- @param opts ReactNativeComponentOptions
local component_func = function(opts)
  local has_props = opts.props or opts.forward
  local forward = opts.forward
  local typescript = opts.typescript

  local parts = {}
  table.insert(parts, t("function "))
  table.insert(parts, i(1, util.get_filename())) -- Component name is now an editable insert node.
  table.insert(parts, t("("))

  if forward then
    if typescript then
      table.insert(parts, t("props: "))
      table.insert(
        parts,
        f(function(nodes)
          return nodes[1] .. "Props"
        end, { 1 })
      )
      table.insert(parts, t(", ref): ReactElement {"))
    else
      table.insert(parts, t("props, ref) {"))
    end
  elseif typescript then
    if has_props then
      table.insert(parts, t("props: " .. (config.readonly_props and "Readonly<" or "")))
      table.insert(
        parts,
        f(function(nodes)
          return nodes[1] .. "Props"
        end, { 1 })
      )
      table.insert(parts, t((config.readonly_props and ">" or "")))
    end
    table.insert(parts, t("): ReactElement {"))
  elseif has_props then
    table.insert(parts, t("props) {"))
  else
    table.insert(parts, t(") {"))
  end
  table.insert(parts, t({ "", "" }))

  return parts
end

--- Generates the 'forwardRef' wrapper.
--- @param opts ReactNativeComponentOptions
local forward_ref = function(opts)
  if not opts.forward then
    return {}
  end

  local types = {}
  if opts.typescript then
    table.insert(types, t("<"))
    table.insert(types, i(3, "View")) -- The element type to forward to.
    table.insert(types, t(", "))
    table.insert(
      types,
      f(function(nodes)
        return nodes[1] .. "Props"
      end, { 1 })
    )
    table.insert(types, t(">"))
  end

  return util.merge_lists({ t("forwardRef") }, types, { t("(") })
end

--- Generates the complete export line for the component.
--- @param opts ReactNativeComponentOptions
local component_export_line = function(opts)
  local export = opts.export ~= false
  local default = opts.export == "default"
  local forward = opts.forward
  local maybe_const = (
    not default
    and forward
    and {
      t("const "),
      f(function(nodes)
        return nodes[1]
      end, { 1 }),
      t(" = "),
    }
  ) or {}

  return util.merge_lists({
    t((export and "export " or "") .. (default and "default " or "")),
  }, maybe_const, forward_ref(opts), component_func(opts))
end

--- Generates the JSX body of the component.
--- @param opts ReactNativeComponentOptions
local component_body = function(opts)
  local body_content = {
    t("\t\t\t"),
    i(0, "<Text>Hello from " .. util.get_filename() .. "</Text>"), -- Final cursor position
  }

  local view_tag = opts.forward and "<View ref={ref}>" or "<View>"

  return {
    t({ "\treturn (", "" }),
    t({ "\t\t" .. view_tag, "" }),
    unpack(body_content),
    t({ "", "\t\t</View>", "" }),
    t({ "\t)", "" }),
  }
end

--- Generates the StyleSheet block.
--- @return unknown[]
local stylesheet = function()
  return {
    t({ "", "" }),
    t({ "const styles = StyleSheet.create({", "" }),
    t("\t"),
    i(4, "container: {},"), -- Stylesheet content
    t({ "", "})", "" }),
  }
end

--- The main snippet builder function.
--- @param opts ReactNativeComponentOptions
local native_component = function(opts)
  opts.props = opts.props or false
  opts.forward = opts.forward or false

  local has_props = opts.props or opts.forward
  local forward = opts.forward
  local simple = not has_props and not forward
  local export = opts.export ~= false
  local default = opts.export == "default"

  local trig = "rn"
    .. (simple and "s" or "")
    .. (forward and "f" or "")
    .. "c"
    .. (default and "d" or "")
    .. (export and "e" or "")

  local desc = "React Native "
    .. (simple and "Simple " or "")
    .. (forward and "ForwardRef " or "")
    .. "Component "
    .. (default and "Default " or "")
    .. (export and "Export" or "")

  return s(
    {
      trig = trig,
      desc = desc,
    },
    util.merge_lists(
      all_imports(opts),
      component_props(opts),
      component_export_line(opts),
      component_body(opts),
      { t("}" .. (opts.forward and ")" or "") .. "\n") },
      stylesheet()
    )
  )
end

--- Generates all component variations.
--- @param typescript boolean
local native_components = function(typescript)
  return {
    -- With props: rnc, rnce, rncde
    native_component({ props = true, export = false, forward = false, typescript = typescript }),
    native_component({ props = true, export = true, forward = false, typescript = typescript }),
    native_component({ props = true, export = "default", forward = false, typescript = typescript }),

    -- Simple (no props): rnsc, rnsce, rnscde
    native_component({ props = false, export = false, forward = false, typescript = typescript }),
    native_component({ props = false, export = true, forward = false, typescript = typescript }),
    native_component({ props = false, export = "default", forward = false, typescript = typescript }),

    -- ForwardRef (with props): rnfc, rnfce, rnfcde
    native_component({ props = true, export = false, forward = true, typescript = typescript }),
    native_component({ props = true, export = true, forward = true, typescript = typescript }),
    native_component({ props = true, export = "default", forward = true, typescript = typescript }),
  }
end

return native_components
