local var0_0 = class("GameTrackerBuilder")
local var1_0 = ";"
local var2_0 = "`"

function var0_0.SerializedItem(arg0_1)
	local var0_1 = table.concat(arg0_1.int_args or {}, var2_0)
	local var1_1 = table.concat(arg0_1.str_args or {}, var2_0)

	return table.concat({
		arg0_1.track_typ or "",
		arg0_1.track_time or "",
		var0_1 or "",
		var1_1 or ""
	}, var1_0)
end

function var0_0.DeSerializedItem(arg0_2)
	local var0_2 = string.split(arg0_2, var1_0)

	if #var0_2 < 2 then
		return false
	end

	local var1_2 = tonumber(var0_2[1] or "")
	local var2_2 = tonumber(var0_2[2] or "")

	if var1_2 == nil or var2_2 == nil then
		return false
	end

	local var3_2 = var0_2[3] or ""
	local var4_2 = string.split(var3_2, var2_0)
	local var5_2 = {}

	for iter0_2, iter1_2 in ipairs(var4_2) do
		local var6_2 = tonumber(iter1_2)

		if var6_2 then
			table.insert(var5_2, var6_2)
		end
	end

	local var7_2 = var0_2[4] or ""
	local var8_2 = string.split(var7_2, var2_0)

	return {
		track_typ = var1_2,
		track_time = var2_2,
		int_args = var5_2,
		str_args = var8_2
	}
end

local function var3_0(arg0_3, arg1_3, arg2_3)
	local var0_3 = {}
	local var1_3 = {}

	for iter0_3, iter1_3 in ipairs(arg1_3) do
		table.insert(var0_3, tonumber(iter1_3 .. ""))
	end

	for iter2_3, iter3_3 in ipairs(arg2_3) do
		table.insert(var1_3, tostring(iter3_3))
	end

	local var2_3 = pg.TimeMgr.GetInstance():GetServerTime()

	return {
		track_typ = arg0_3,
		track_time = var2_3,
		int_args = var0_3,
		str_args = var1_3
	}
end

function var0_0.BuildStoryStart(arg0_4, arg1_4)
	return var3_0(18, {
		1,
		arg0_4,
		arg1_4
	}, {})
end

function var0_0.BuildStorySkip(arg0_5, arg1_5)
	return var3_0(18, {
		2,
		arg0_5,
		arg1_5
	}, {})
end

function var0_0.BuildNotice(arg0_6)
	return var3_0(19, {}, {
		arg0_6
	})
end

function var0_0.BuildStoryOption(arg0_7, arg1_7)
	return var3_0(20, {
		arg0_7
	}, {
		arg1_7
	})
end

function var0_0.BuildEmoji(arg0_8)
	local var0_8 = "777#(%d+)#777"
	local var1_8 = arg0_8:match(var0_8)
	local var2_8 = tonumber(var1_8)

	if var2_8 and var2_8 > 0 then
		return var3_0(21, {
			var2_8
		}, {})
	else
		return var3_0(21, {
			0
		}, {})
	end
end

function var0_0.BuildExitSilentView(arg0_9, arg1_9, arg2_9)
	return var3_0(22, {
		arg0_9,
		arg1_9
	}, {
		arg2_9
	})
end

function var0_0.BuildTouchBanner(arg0_10)
	return var3_0(23, {}, {
		arg0_10
	})
end

function var0_0.BuildSwitchPainting(arg0_11, arg1_11)
	return var3_0(24, {
		arg0_11,
		arg1_11
	}, {})
end

function var0_0.BuildHubGames(arg0_12, arg1_12, arg2_12)
	return var3_0(25, {
		arg0_12,
		arg1_12
	}, {
		arg2_12
	})
end

function var0_0.BuildUrRedeem(arg0_13, arg1_13)
	return var3_0(26, {
		arg0_13
	}, {
		arg1_13
	})
end

function var0_0.BuildUrJump(arg0_14)
	return var3_0(27, {}, {
		arg0_14
	})
end

function var0_0.BuildDorm3d(arg0_15)
	return var3_0(arg0_15.track_typ, arg0_15.int_args, arg0_15.str_args)
end

function var0_0.BuildNewEducate(arg0_16)
	return var3_0(arg0_16.track_typ, arg0_16.int_args, arg0_16.str_args)
end

function var0_0.BuildNewMainUI(arg0_17)
	return var3_0(28, {
		arg0_17.isNewMainUI,
		arg0_17.isLogin
	}, {})
end

function var0_0.BuildGuide(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	if arg0_18 then
		return var3_0(30, {
			arg1_18,
			arg2_18,
			arg3_18
		}, {
			arg4_18
		})
	else
		return var3_0(29, {
			arg1_18,
			arg2_18,
			arg3_18
		}, {
			arg4_18
		})
	end
end

function var0_0.BuildPhantom(arg0_19)
	return var3_0(31, {
		arg0_19
	}, {})
end

function var0_0.BuildFushunAdventure()
	return var3_0(35, {}, {})
end

function var0_0.BuildAllCollection(arg0_21, arg1_21)
	return var3_0(arg0_21, {
		arg1_21
	}, {})
end

function var0_0.BuildIslandVisit(arg0_22)
	if getProxy(FriendProxy):getFriend(arg0_22) then
		return var3_0(30046, {
			arg0_22,
			1
		}, {})
	end

	local var0_22 = getProxy(GuildProxy):getRawData()

	if var0_22 and var0_22:getMemberById(arg0_22) then
		return var3_0(30046, {
			arg0_22,
			2
		}, {})
	end

	return nil
end

function var0_0.BuildIslandVisitByCode()
	return var3_0(30046, {
		0,
		3
	}, {})
end

function var0_0.BuildIslandAgoraUpgrade(arg0_24)
	return var3_0(30010, {
		arg0_24
	}, {})
end

function var0_0.BuildIslandFurnitureAdd(arg0_25, arg1_25)
	return var3_0(30040, {
		arg0_25
	}, {
		arg1_25
	})
end

function var0_0.BuildIslandAgoraSave()
	return var3_0(30041, {}, {})
end

function var0_0.BuildIslandSignIn()
	return var3_0(30006, {}, {})
end

function var0_0.BuildIslandGetGift(arg0_28)
	return var3_0(30007, {
		arg0_28
	}, {})
end

function var0_0.BuildIslandInvitation(arg0_29)
	if #arg0_29 == 0 then
		return var3_0(30008, {
			0
		}, {})
	else
		return var3_0(30008, {
			2
		}, {})
	end
end

function var0_0.BuildIslandShareSignIn()
	return var3_0(30008, {
		1
	}, {})
end

function var0_0.BuildIslandUnlockMap(arg0_31)
	return var3_0(30004, {
		arg0_31
	}, {})
end

function var0_0.BuildMapExit(arg0_32, arg1_32)
	return var3_0(30009, {
		arg0_32,
		arg1_32
	}, {})
end

function var0_0.BuildIslandUnlockShip(arg0_33)
	return var3_0(30013, {
		arg0_33
	}, {})
end

function var0_0.BuildIslandShipUpgrade(arg0_34, arg1_34)
	return var3_0(30014, {
		arg0_34,
		arg1_34
	}, {})
end

function var0_0.BuildIslandShipBreakout(arg0_35, arg1_35)
	return var3_0(30015, {
		arg0_35,
		arg1_35
	}, {})
end

function var0_0.BuildIslandShipSkillUpgrade(arg0_36, arg1_36, arg2_36)
	return var3_0(30016, {
		arg0_36,
		arg1_36,
		arg2_36
	}, {})
end

function var0_0.BuildIslandShipAddBuff(arg0_37, arg1_37)
	return var3_0(30019, {
		arg0_37,
		arg1_37
	}, {})
end

function var0_0.BuildIslandShipGiveGift(arg0_38, arg1_38)
	return var3_0(30020, {
		arg0_38,
		arg1_38
	}, {})
end

function var0_0.BuildIslandShipAttrUpgrade(arg0_39, arg1_39)
	local var0_39 = {}
	local var1_39 = {}

	for iter0_39, iter1_39 in pairs(arg1_39:GetAttrs()) do
		local var2_39 = arg0_39:GetAttr(iter0_39)

		table.insert(var0_39, string.format("{%s,%s}", iter0_39, iter1_39 - var2_39))
		table.insert(var1_39, string.format("{%s,%s}", iter0_39, iter1_39))
	end

	local var3_39 = table.concat(var0_39, ",")
	local var4_39 = table.concat(var1_39, ",")

	return var3_0(30017, {
		arg0_39.id
	}, {
		var3_39,
		var4_39
	})
end

function var0_0.BuildIslandShipAttrLimit(arg0_40, arg1_40)
	local var0_40 = {}

	for iter0_40, iter1_40 in pairs(arg1_40:GetAttrs()) do
		local var1_40 = arg1_40:GetExtraAttrLimit(iter0_40)
		local var2_40 = arg0_40:GetExtraAttrLimit(iter0_40)

		table.insert(var0_40, string.format("{%s,%s,%s}", iter0_40, var2_40, var1_40))
	end

	local var3_40 = table.concat(var0_40, ",")

	return var3_0(30018, {
		arg0_40.id
	}, {
		var3_40
	})
end

function var0_0.BuildIslandUpgrade(arg0_41)
	return var3_0(30003, {
		arg0_41
	}, {})
end

function var0_0.BuildIslandInventoryUpgrade(arg0_42)
	return var3_0(30011, {
		arg0_42
	}, {})
end

function var0_0.BuildIslandInventoryChange(arg0_43, arg1_43, arg2_43)
	return var3_0(30012, {
		arg0_43,
		arg1_43,
		arg2_43
	}, {})
end

function var0_0.BuildIslandSubmitOrder(arg0_44, arg1_44)
	return var3_0(30031, {
		arg0_44,
		arg1_44
	}, {})
end

function var0_0.BuildIslandGuide(arg0_45, arg1_45, arg2_45)
	return var3_0(30001, {
		arg0_45,
		arg1_45
	}, {
		arg2_45
	})
end

function var0_0.BuildIslandRestUpgrade(arg0_46, arg1_46)
	return var3_0(30050, {
		arg0_46,
		arg1_46
	}, {})
end

function var0_0.BuildIslandDeviceBanner(arg0_47)
	return var3_0(30005, {
		arg0_47
	}, {})
end

function var0_0.BuildIslandEnter(arg0_48, arg1_48)
	return var3_0(30002, {
		arg0_48,
		arg1_48
	}, {})
end

function var0_0.BuildIslandTechImmd(arg0_49)
	return var3_0(30034, {
		arg0_49
	}, {})
end

function var0_0.BuildIslandWildGather(arg0_50)
	return var3_0(30021, {
		arg0_50
	}, {})
end

function var0_0.BuildIslandWildCollect(arg0_51)
	return var3_0(30042, {
		arg0_51
	}, {})
end

function var0_0.BuildIslandGetDress(arg0_52, arg1_52)
	return var3_0(30037, {
		arg0_52,
		arg1_52
	}, {})
end

function var0_0.BuildIslandBindDress(arg0_53, arg1_53)
	return var3_0(30038, {
		arg0_53,
		arg1_53
	}, {})
end

function var0_0.BuildIslandWearDress(arg0_54, arg1_54)
	local var0_54 = "["

	for iter0_54, iter1_54 in ipairs(arg1_54) do
		local var1_54 = pg.island_dress_template[iter1_54.dress_id].type

		var0_54 = var0_54 .. string.format("{\"type\":%d,\"id\":%d}", var1_54, iter1_54.dress_id)

		if iter0_54 ~= #arg1_54 then
			var0_54 = var0_54 .. ","
		end
	end

	local var2_54 = var0_54 .. "]"

	return var3_0(30039, {
		arg0_54
	}, {
		var2_54
	})
end

function var0_0.BuildIslandStartDelegation(arg0_55, arg1_55, arg2_55, arg3_55, arg4_55)
	return var3_0(30022, {
		arg0_55,
		arg1_55,
		arg2_55,
		arg3_55,
		arg4_55
	}, {})
end

function var0_0.BuildIslandGetDelegationAward(arg0_56, arg1_56)
	local var0_56 = "["

	for iter0_56, iter1_56 in ipairs(arg1_56) do
		var0_56 = var0_56 .. string.format("{\"type\":%d,\"id\":%d,\"num\":%d}", iter1_56.type, iter1_56.id, iter1_56.number)

		if iter0_56 ~= #arg1_56 then
			var0_56 = var0_56 .. ","
		end
	end

	local var1_56 = var0_56 .. "]"

	return var3_0(30023, {
		arg0_56
	}, {
		var1_56
	})
end

function var0_0.BuildIslandShopBuy(arg0_57, arg1_57)
	return var3_0(30035, {
		arg0_57,
		arg1_57
	}, {})
end

function var0_0.BuildIslandUnlockColor(arg0_58, arg1_58)
	return var3_0(30051, {
		arg0_58,
		arg1_58
	}, {})
end

function var0_0.BuildActionOp(arg0_59, arg1_59, arg2_59, arg3_59, arg4_59, arg5_59)
	return var3_0(30062, {
		arg0_59,
		arg1_59,
		arg2_59,
		arg3_59,
		arg5_59,
		arg4_59
	}, {})
end

function var0_0.BuildIslandCloseRest(arg0_60, arg1_60)
	local var0_60 = "["

	for iter0_60, iter1_60 in ipairs(arg1_60) do
		var0_60 = var0_60 .. string.format("{\"type\":%d,\"id\":%d,\"num\":%d}", iter1_60.type, iter1_60.id, iter1_60.number)

		if iter0_60 ~= #arg1_60 then
			var0_60 = var0_60 .. ","
		end
	end

	local var1_60 = var0_60 .. "]"

	return var3_0(30059, {
		arg0_60
	}, {
		var1_60
	})
end

function var0_0.BuildIslandTakeThoto(arg0_61)
	return var3_0(30060, {
		arg0_61
	}, {})
end

function var0_0.BuildIslandFishingEnter(arg0_62)
	return var3_0(30065, {
		arg0_62,
		0,
		0
	}, {})
end

function var0_0.BuildIslandFishingExit(arg0_63, arg1_63)
	return var3_0(30065, {
		arg0_63,
		1,
		arg1_63
	}, {})
end

function var0_0.BuildIslandFishingChangeLure(arg0_64, arg1_64, arg2_64)
	return var3_0(30066, {
		arg0_64,
		arg1_64,
		arg2_64
	}, {})
end

function var0_0.BuildIslandFishingResult(arg0_65, arg1_65, arg2_65, arg3_65, arg4_65, arg5_65, arg6_65, arg7_65, arg8_65, arg9_65)
	return var3_0(30067, {
		arg0_65,
		arg1_65,
		arg2_65,
		arg3_65,
		arg4_65,
		arg5_65,
		arg6_65,
		arg7_65,
		arg8_65,
		arg9_65
	}, {})
end

function var0_0.BuildIslandFishingCancel(arg0_66, arg1_66)
	return var3_0(30068, {
		arg0_66,
		arg1_66
	}, {})
end

function var0_0.BuildJuusOfficialAccountsClick(arg0_67)
	return var3_0(40002, {
		arg0_67
	}, {})
end

function var0_0.BuildPlayRoomInvate(arg0_68, arg1_68, arg2_68)
	return var3_0(30076, {
		arg1_68,
		arg2_68
	}, {
		arg0_68
	})
end

function var0_0.BuildPlayRoomMatch(arg0_69, arg1_69, arg2_69, arg3_69, arg4_69)
	return var3_0(30074, {
		arg1_69,
		arg2_69,
		arg3_69,
		arg4_69
	}, {
		arg0_69
	})
end

function var0_0.BuildCheaterTavernGame(arg0_70, arg1_70)
	return var3_0(30072, {
		arg0_70,
		arg1_70
	}, {})
end

function var0_0.BuildCheaterTavernResult(arg0_71, arg1_71, arg2_71, arg3_71, arg4_71, arg5_71)
	return var3_0(30073, {
		arg0_71,
		arg1_71,
		arg2_71,
		arg3_71,
		arg4_71,
		arg5_71
	}, {})
end

function var0_0.BuildAuctionEnter()
	return var3_0(50001, {}, {})
end

function var0_0.BuildAuctionHelp()
	return var3_0(50002, {}, {})
end

function var0_0.BuildPreorder(arg0_74, arg1_74)
	return var3_0(50003, {
		arg0_74,
		arg1_74
	}, {})
end

function var0_0.BuildNameCard(arg0_75, arg1_75)
	return var3_0(50004, {
		arg0_75,
		arg1_75
	}, {})
end

function var0_0.BuildAuctionSettlement(arg0_76, arg1_76, arg2_76, arg3_76, arg4_76, arg5_76)
	return var3_0(50005, {
		arg1_76,
		arg2_76,
		arg3_76,
		arg4_76,
		arg5_76
	}, {
		arg0_76
	})
end

function var0_0.BuildAuctionMatching(arg0_77, arg1_77, arg2_77)
	return var3_0(50006, {
		arg0_77,
		arg1_77,
		arg2_77
	}, {})
end

function var0_0.BuildAuctionChooseEvent(arg0_78, arg1_78, arg2_78, arg3_78)
	return var3_0(50007, {
		arg0_78,
		arg1_78,
		arg2_78,
		arg3_78
	}, {})
end

function var0_0.BuildAuctionBid(arg0_79, arg1_79, arg2_79, arg3_79, arg4_79)
	return var3_0(50008, {
		arg0_79,
		arg1_79,
		arg2_79,
		arg3_79,
		arg4_79
	}, {})
end

function var0_0.BuildAuctionFinish(arg0_80, arg1_80, arg2_80)
	return var3_0(50009, {
		arg0_80,
		arg1_80,
		arg2_80
	}, {})
end

function var0_0.BuildAuctionExit(arg0_81, arg1_81)
	return var3_0(50010, {
		arg0_81,
		arg1_81
	}, {})
end

return var0_0
