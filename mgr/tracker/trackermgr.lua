pg = pg or {}
pg.TrackerMgr = singletonClass("TrackerMgr")

local var0 = pg.TrackerMgr

TRACKING_ROLE_CREATE = "role_create"
TRACKING_ROLE_LOGIN = "role_login"
TRACKING_TUTORIAL_COMPLETE_1 = "tutorial_complete_1"
TRACKING_TUTORIAL_COMPLETE_2 = "tutorial_complete_2"
TRACKING_TUTORIAL_COMPLETE_3 = "tutorial_complete_3"
TRACKING_TUTORIAL_COMPLETE_4 = "tutorial_complete_4"
TRACKING_USER_LEVELUP = "user_levelup"
TRACKING_ROLE_LOGOUT = "role_logout"
TRACKING_PURCHASE_FIRST = "purchase_first"
TRACKING_PURCHASE_CLICK = "purchase_click"
TRACKING_PURCHASE_CLICK_MONTHLYCARD = "purchase_click_monthlycard"
TRACKING_PURCHASE_CLICK_GIFTBAG = "purchase_click_giftbag"
TRACKING_PURCHASE_CLICK_DIAMOND = "purchase_click_diamond"
TRACKING_PURCHASE = "purchase"
TRACKING_2D_RETENTION = "2d_retention"
TRACKING_7D_RETENTION = "7d_retention"
TRACKING_BUILD_SHIP = "build_ship"
TRACKING_SHIP_INTENSIFY = "ship_intensify"
TRACKING_SHIP_LEVEL_UP = "ship_level_up"
TRACKING_SHIP_HIGHEST_LEVEL = "ship_highest_level"
TRACKING_CUBE_ADD = "cube_add"
TRACKING_CUBE_CONSUME = "cube_consume"
TRACKING_USER_LEVEL_THIRTY = "user_level_thirty"
TRACKING_USER_LEVEL_FORTY = "user_level_forty"
TRACKING_PROPOSE_SHIP = "propose_ship"
TRACKING_REMOULD_SHIP = "remould_ship"
TRACKING_HARD_CHAPTER = "hard_chapter"
TRACKING_KILL_BOSS = "kill_boss"
TRACKING_HIGHEST_CHAPTER = "highest_chapter"
TRACKING_SHIPWORKS_COMPLETE = "shipworks_complete"
TRACKING_FIRST_PASS_3_4 = "first_pass_3-4"
TRACKING_FIRST_PASS_4_4 = "first_pass_4-4"
TRACKING_FIRST_PASS_5_4 = "first_pass_5-4"
TRACKING_FIRST_PASS_6_4 = "first_pass_6-4"
TRACKING_FIRST_PASS_12_4 = "first_pass_12_4"
TRACKING_FIRST_PASS_13_1 = "first_pass_13_1"
TRACKING_FIRST_PASS_13_2 = "first_pass_13_2"
TRACKING_FIRST_PASS_13_3 = "first_pass_13_3"
TRACKING_FIRST_PASS_13_4 = "first_pass_13_4"
TRACKING_CLASS_LEVEL_UP_8 = "class_level_up_8"
TRACKING_CLASS_LEVEL_UP_9 = "class_level_up_9"
TRACKING_CLASS_LEVEL_UP_10 = "class_level_up_10"

function var0.Ctor(arg0)
	local var0

	if PLATFORM_CODE == PLATFORM_CH then
		var0 = require("Mgr.Tracker.BiliTracker")
	elseif PLATFORM_CODE == PLATFORM_JP then
		var0 = require("Mgr.Tracker.AiriJPTracker")
	elseif PLATFORM_CODE == PLATFORM_US then
		var0 = require("Mgr.Tracker.AiriUSTracker")
	elseif PLATFORM_CODE == PLATFORM_KR then
		var0 = require("Mgr.Tracker.KwxyKrTracker")
	elseif PLATFORM_CODE == PLATFORM_CHT then
		var0 = require("Mgr.Tracker.YongshiTracker")
	end

	if var0 then
		arg0.instance = var0.New()
	end
end

function var0.Call(arg0, arg1, ...)
	if arg0.instance and arg0.instance[arg1] then
		arg0.instance[arg1](arg0.instance, ...)
	end
end

function var0.Tracking(arg0, arg1, arg2, arg3)
	local var0 = getProxy(UserProxy)
	local var1 = var0 ~= nil and var0:getData() or nil
	local var2 = var1 ~= nil and var1.uid or nil

	if var2 == nil then
		return
	end

	local var3 = getProxy(PlayerProxy)
	local var4 = var3 ~= nil and var3:getData() or nil
	local var5 = var4 ~= nil and var4.id or nil

	var5 = var5 ~= nil and var5 or arg3

	if var5 == nil then
		return
	end

	local var6 = getProxy(ServerProxy):getLastServer(var2).id

	if arg1 == TRACKING_2D_RETENTION or arg1 == TRACKING_7D_RETENTION then
		local var7 = "tracking_" .. arg1

		if PlayerPrefs.GetInt(var7, 0) <= 0 then
			originalPrint("tracking type : " .. arg1 .. "   user_id:" .. var5)
			PlayerPrefs.SetInt(var7, 1)
			PlayerPrefs.Save()
			arg0:Call("Tracking", arg1, var5, arg2)
		end
	else
		originalPrint("tracking type : " .. arg1 .. ",   user_id:" .. var5 .. ",   data:" .. (arg2 or "nil"))
		arg0:Call("Tracking", arg1, var5, arg2, var6)
	end

	if arg1 == TRACKING_PURCHASE_CLICK then
		if arg2 == 1 then
			originalPrint("tracking type : " .. TRACKING_PURCHASE_CLICK_MONTHLYCARD .. "   user_id:" .. var5)
			arg0:Call("Tracking", TRACKING_PURCHASE_CLICK_MONTHLYCARD, var5, arg2)
		elseif arg2 == 2 then
			originalPrint("tracking type : " .. TRACKING_PURCHASE_CLICK_GIFTBAG .. "   user_id:" .. var5)
			arg0:Call("Tracking", TRACKING_PURCHASE_CLICK_GIFTBAG, var5, arg2)
		else
			originalPrint("tracking type : " .. TRACKING_PURCHASE_CLICK_DIAMOND .. "   user_id:" .. var5)
			arg0:Call("Tracking", TRACKING_PURCHASE_CLICK_DIAMOND, var5, arg2)
		end
	end
end
