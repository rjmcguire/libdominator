/**
 * Copyright:
 * (C) 2016 Martin Brzenska
 *
 * License: 
 * Distributed under the terms of the MIT license. 
 * Consult the provided LICENSE.md file for details
 */
module libdominator.Output;

import std.conv : to;
import std.array;
import std.algorithm;
import std.string : lastIndexOf;
import std.stdio;

import libdominator.Attribute;
import libdominator.Dominator;
import libdominator.Node;

string[] nodeOutputItems(ref Dominator dom, Node node, string[] optOutItems)
{
  string[] columns;
  foreach(string optOutItem ; optOutItems)
  {
    switch(optOutItem)
    {
      case "tag":
        columns ~= node.getTag();
      break;
      case "element-opener":
        columns ~= dom.getStartElement(node);
        break;
      case "element":
        columns ~= dom.getElelment(node);
      break;
      case "element-start":
        columns ~= to!string(node.getStartPosition());
      break;
      case "element-end":
        columns ~= to!string(node.getEndPosition());
      break;
      case "element-inner":
        columns ~= dom.getInner(node);
      break;
      case "attrib-keys":
        columns ~= join(map!(a => a.key)(node.getAttributes()),",");
      break;
      default:
        /*
        * some CLI-Arguments are parametrized, lets check them
        */
        if(optOutItem.length > 7 && optOutItem[0..7] == "attrib(")
        {
          size_t closerIndex = lastIndexOf(optOutItem, ")");
          if(closerIndex) 
          { 
            string[] keyvalues;
            foreach(Attribute fAttrib ; node.getAttributes().filter!(a => a.key == optOutItem[7..closerIndex]))
            {
              keyvalues ~= fAttrib.values;
            }
            columns ~= join(keyvalues, ",");
          }
        }
      break;
    }
  }
  return columns;
}