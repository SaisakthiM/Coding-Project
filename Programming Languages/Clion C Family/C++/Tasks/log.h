#pragma once

#include <any>
#include <string>
#include <variant>
int log(int a) {
    return a;
} 

struct Log {

  static void printLog(const std::any& value) {
    printf("%s",std::any_cast<std::string>(&value));
  };

};