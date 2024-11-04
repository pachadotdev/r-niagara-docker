#include <cpp11.hpp>
using namespace cpp11;

[[cpp11::register]] int two_() {
  int x = 1;
  int y = 1;
  return x + y;
}
