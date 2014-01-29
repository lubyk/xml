#include "xml/Parser.h"
#include "rapidxml.hpp"

#include <string>


xml::Parser::Parser(Type type) 
  : type_(type) {
}

xml::Parser::~Parser() {
}

static void parseDom(lua_State *L, rapidxml::xml_node<> *node) {
  lua_newtable(L);
  // <tbl>
  int tbl_pos = lua_gettop(L);

  lua_pushlstring(L, node->name(), node->name_size());
  // <tbl> "tag"
  lua_setfield(L, -2, "xml");
  // <tbl>

  // Parse attributes
  for (rapidxml::xml_attribute<> *attr = node->first_attribute();
      attr; attr = attr->next_attribute()) {
    // <tbl>
    lua_pushlstring(L, attr->name(), attr->name_size());
    // <tbl> "key"
    lua_pushlstring(L, attr->value(), attr->value_size());
    // <tbl> "key" "value"
    lua_rawset(L, tbl_pos);
  }
  // <tbl>

  // Parse children nodes
  int pos = 0;
  for(rapidxml::xml_node<> *child = node->first_node();
      child; child = child->next_sibling()) {
    // <tbl>
    switch(child->type()) {
      case rapidxml::node_element:
        parseDom(L, child);
        break;
      case rapidxml::node_data:        // continue
      case rapidxml::node_cdata:
        lua_pushlstring(L, child->value(), child->value_size());
        break;
      case rapidxml::node_comment:     // continue
      case rapidxml::node_declaration: // continue
      case rapidxml::node_doctype:     // continue
      case rapidxml::node_pi:          // continue
      default:
        // ignore
        continue;
    }
        
    // <tbl> <child>
    lua_rawseti(L, tbl_pos, ++pos);
  }
  // <tbl>
}

// Simple helper class to handle copy and auto freeing.
struct String {
  char *text_;
  String(const char *text, size_t len) : text_(NULL) {
    text_ = (char*)malloc(len * sizeof(char));
    if (text_) {
      strncpy(text_, text, len);
    }
  }

  ~String() {
    if (text_) {
      free(text_);
    }
  }
};

// Receive an xml string and return a Lua table.
LuaStackSize xml::Parser::load(lua_State *L) {
  size_t len;
  const char *xml_str = dub::checklstring(L, 2, &len);
  ++len; // for \0 termination
  rapidxml::xml_document<> doc;  // character type defaults to char

  switch(type_) {
    case NonDestructive:
      doc.parse<rapidxml::parse_non_destructive>(const_cast<char *>(xml_str));
      parseDom(L, doc.first_node());
      return 1;
    case TrimWhitespace: {
      // Parsing is destructive: make an exception safe copy.
      String text(xml_str, len);
      if (!text.text_) return 0;        
      doc.parse<rapidxml::parse_trim_whitespace>(text.text_);
      parseDom(L, doc.first_node());
      // <tbl>
      return 1;
    }
    case Default: // continue
    default: {
      // Parsing is destructive: make an exception safe copy.
      String text(xml_str, len);
      if (!text.text_) return 0;        
      doc.parse<rapidxml::parse_default>(text.text_);
      parseDom(L, doc.first_node());
      // <tbl>
      return 1;
    }
  }
}

