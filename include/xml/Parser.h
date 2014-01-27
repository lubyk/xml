/*
  ==============================================================================

   This file is part of the LUBYK project (http://lubyk.org)
   Copyright (c) 2007-2014 by Gaspard Bucher (http://teti.ch).

  ------------------------------------------------------------------------------

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.

  ==============================================================================
*/

#ifndef LUBYK_INCLUDE_XML_PARSER_H_
#define LUBYK_INCLUDE_XML_PARSER_H_

#include "dub/dub.h" // dub::Exception

namespace xml {

/** Simple xml parser (singleton).
 */
class Parser {
public:
  enum Type {
    Default = 0,             
    TrimWhitespace,
    NonDestructive,
    Fastest,
  };

  Parser(Type type = Default);
  ~Parser();

  // Receive an xml string and return a Lua table. The received string can be
  // modified in place.
  LuaStackSize parse(lua_State *L);
private:
  Type type_;

  class Implementation;
  Implementation *impl_;

};

} // xml

#endif // LUBYK_INCLUDE_XML_PARSER_H_


