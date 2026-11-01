package.path = package.path .. ";../src/?.lua;./src/?.lua;../src/deprecated/?.lua;./src/deprecated/?.lua"
local dc_old = require("old_seedtype")
local dc_new = require("decktypes")
local ss_old = require("old_seedset").SeedSet
local ss_new = require("seedset").SeedSet

local ss_old_italian = ss_old:new(dc_old.ITALIAN.DENARE, 10)
local ss_new_italian = ss_new:new(dc_new.ITALIAN.DENARE)

print(tostring(ss_old_italian))
print(tostring(ss_new_italian))

local ss_old_poker = ss_old:new(dc_old.POKER.HEARTS, 13)
local ss_new_poker = ss_new:new(dc_new.POKER.HEARTS)

print(tostring(ss_old_poker))
print(tostring(ss_new_poker))

local ss_old_mahjong = ss_old:new(dc_old.MAHJONG.BAMBOO, 9)
local ss_new_mahjong = ss_new:new(dc_new.MAHJONG.BAMBOO)

print(tostring(ss_old_mahjong))
print(tostring(ss_new_mahjong))

local ss_new_uno = ss_new:new(dc_new.UNO.RED)
print(tostring(ss_new_uno))
