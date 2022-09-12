// Copyright 2022 Google LLC.
// SPDX-License-Identifier: Apache-2.0

pub fn user_module(io_in: u8) -> u8 {
  io_in
}

#![test]
fn user_module_test() {
  let _= assert_eq(user_module(u8:0b0010_1010), u8:42);
  _
}
