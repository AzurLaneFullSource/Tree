pg = pg or {}
pg.TrackerMgr = singletonClass("TrackerMgr")

local var0_0 = pg.TrackerMgr

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

function var0_0.Ctor(arg0_1)
	local var0_1

	if PLATFORM_CODE == PLATFORM_CH then
		var0_1 = require("Mgr.Tracker.BiliTracker")
	elseif PLATFORM_CODE == PLATFORM_JP then
		var0_1 = require("Mgr.Tracker.AiriJPTracker")
	elseif PLATFORM_CODE == PLATFORM_US then
		var0_1 = require("Mgr.Tracker.AiriUSTracker")
	elseif PLATFORM_CODE == PLATFORM_KR then
		var0_1 = require("Mgr.Tracker.KwxyKrTracker")
	elseif PLATFORM_CODE == PLATFORM_CHT then
		var0_1 = require("Mgr.Tracker.YongshiTracker")
	end

	if var0_1 then
		arg0_1.instance = var0_1.New()
	end
end

function var0_0.Call(arg0_2, arg1_2, ...)
	if arg0_2.instance and arg0_2.instance[arg1_2] then
		arg0_2.instance[arg1_2](arg0_2.instance, ...)
	end
end

function var0_0.Tracking(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = getProxy(UserProxy)
	local var1_3 = var0_3 ~= nil and var0_3:getData() or nil
	local var2_3 = var1_3 ~= nil and var1_3.uid or nil

	if var2_3 == nil then
		return
	end

	local var3_3 = getProxy(PlayerProxy)
	local var4_3 = var3_3 ~= nil and var3_3:getData() or nil
	local var5_3 = var4_3 ~= nil and var4_3.id or nil

	var5_3 = var5_3 ~= nil and var5_3 or arg3_3

	if var5_3 == nil then
		return
	end

	local var6_3 = getProxy(ServerProxy):getLastServer(var2_3).id

	if arg1_3 == TRACKING_2D_RETENTION or arg1_3 == TRACKING_7D_RETENTION then
		local var7_3 = "tracking_" .. arg1_3

		if PlayerPrefs.GetInt(var7_3, 0) <= 0 then
			originalPrint("tracking type : " .. arg1_3 .. "   user_id:" .. var5_3)
			PlayerPrefs.SetInt(var7_3, 1)
			PlayerPrefs.Save()
			arg0_3:Call("Tracking", arg1_3, var5_3, arg2_3)
		end
	else
		originalPrint("tracking type : " .. arg1_3 .. ",   user_id:" .. var5_3 .. ",   data:" .. (arg2_3 or "nil"))
		arg0_3:Call("Tracking", arg1_3, var5_3, arg2_3, var6_3)
	end

	if arg1_3 == TRACKING_PURCHASE_CLICK then
		if arg2_3 == 1 then
			originalPrint("tracking type : " .. TRACKING_PURCHASE_CLICK_MONTHLYCARD .. "   user_id:" .. var5_3)
			arg0_3:Call("Tracking", TRACKING_PURCHASE_CLICK_MONTHLYCARD, var5_3, arg2_3)
		elseif arg2_3 == 2 then
			originalPrint("tracking type : " .. TRACKING_PURCHASE_CLICK_GIFTBAG .. "   user_id:" .. var5_3)
			arg0_3:Call("Tracking", TRACKING_PURCHASE_CLICK_GIFTBAG, var5_3, arg2_3)
		else
			originalPrint("tracking type : " .. TRACKING_PURCHASE_CLICK_DIAMOND .. "   user_id:" .. var5_3)
			arg0_3:Call("Tracking", TRACKING_PURCHASE_CLICK_DIAMOND, var5_3, arg2_3)
		end
	end
end
