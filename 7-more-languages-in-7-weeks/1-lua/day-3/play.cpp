extern "C"
{
  #include "lua.h"
  #include "lauxlib.h"
  #include "lualib.h"
}

#include <iostream>

int midi_send(lua_State* L) {
  double status = lua_tonumber(L, -3);
  double data1 = lua_tonumber(L, -2);
  double data2 = lua_tonumber(L, -1);

  std::cout << "midi_send(";
  std::cout << status << ", ";
  std::cout << data1 << ", ";
  std::cout << data2 << ")";
  std::cout << std::endl;

  return 0;
}

int main(int argc, const char* argv[])
{
  if (argc < 1) { return -1; }

  lua_State* L = luaL_newstate();
  luaL_openlibs(L);

  lua_pushcfunction(L, midi_send);
  lua_setglobal(L, "midi_send");

  luaL_dostring(L, "song = require 'notation'");

  if (luaL_dofile(L, argv[1])) {
    std::cerr << lua_tostring(L, -1) << std::endl;
  }

  luaL_dostring(L, "song.go()");

  lua_close(L);
  return 0;
}
