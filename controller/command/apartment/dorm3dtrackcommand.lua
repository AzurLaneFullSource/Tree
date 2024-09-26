local var0_0 = class("Dorm3dTrackCommand", pm.SimpleCommand)

var0_0.TYPE_DORM_ENTER = 1
var0_0.TYPE_DORM_TOUCH = 2
var0_0.TYPE_DORM_DIALOG = 3
var0_0.TYPE_DORM_FAVOR = 4
var0_0.TYPE_DORM_GIFT = 5
var0_0.TYPE_DORM_FURNITURE = 6
var0_0.TYPE_DORM_COLLECTION_ITEM = 7
var0_0.TYPE_DORM_STORY = 8
var0_0.TYPE_DORM_CAMERA = 9
var0_0.TYPE_DORM_COVER = 10
var0_0.TYPE_DORM_DOWNLOAD = 11
var0_0.TYPE_DORM_IK_FURNITURE = 12
var0_0.TYPE_DORM_ROOM = 13
var0_0.TYPE_DORM_ACCOMPANY = 14
var0_0.TYPE_DORM_MINIGAME = 15
var0_0.TYPE_DORM_GUIDE = 16
var0_0.TYPE_DORM_GRAPHICS = 17

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1.body

	print("TRACK DORM3D\n", table.CastToString(var0_1))

	if not pg.ConnectionMgr.GetInstance():getConnection() or not pg.ConnectionMgr.GetInstance():isConnected() then
		return
	end

	local var1_1 = var0_1.args and _.map(_.range(var0_1.args.Count), function(arg0_2)
		return var0_1.args[arg0_2] or 0
	end) or {}
	local var2_1 = var0_1.strs and _.map(_.range(var0_1.strs.Count), function(arg0_3)
		return var0_1.strs[arg0_3] or ""
	end) or {}

	pg.ConnectionMgr.GetInstance():Send(28090, {
		track_typ = var0_1.trackType,
		int_args = var1_1,
		str_args = var2_1
	})
end

function var0_0.BuildDataEnter(arg0_4, arg1_4)
	return {
		trackType = var0_0.TYPE_DORM_ENTER,
		args = {
			arg0_4,
			arg1_4 or 0,
			Count = 2
		}
	}
end

function var0_0.BuildDataTouch(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	return {
		trackType = var0_0.TYPE_DORM_TOUCH,
		args = {
			arg0_5,
			arg1_5,
			arg4_5,
			Count = 3
		},
		strs = {
			arg2_5,
			arg3_5,
			Count = 2
		}
	}
end

function var0_0.BuildDataDialog(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6, arg5_6, arg6_6, arg7_6)
	return {
		trackType = var0_0.TYPE_DORM_DIALOG,
		args = {
			arg0_6,
			arg1_6,
			arg2_6,
			arg3_6,
			arg4_6,
			arg7_6,
			Count = 6
		},
		strs = {
			arg5_6,
			arg6_6,
			Count = 2
		}
	}
end

function var0_0.BuildDataFavor(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	return {
		trackType = var0_0.TYPE_DORM_FAVOR,
		args = {
			arg0_7,
			arg1_7,
			arg2_7,
			arg3_7,
			Count = 4
		},
		strs = {
			arg4_7,
			Count = 1
		}
	}
end

function var0_0.BuildDataGift(arg0_8, arg1_8, arg2_8, arg3_8)
	return {
		trackType = var0_0.TYPE_DORM_GIFT,
		args = {
			arg0_8,
			arg1_8,
			arg2_8,
			Count = 3
		},
		strs = {
			arg3_8,
			Count = 1
		}
	}
end

function var0_0.BuildDataFurniture(arg0_9, arg1_9, arg2_9, arg3_9)
	return {
		trackType = var0_0.TYPE_DORM_FURNITURE,
		args = {
			arg0_9,
			arg1_9,
			arg2_9,
			Count = 3
		},
		strs = {
			arg3_9,
			Count = 1
		}
	}
end

function var0_0.BuildDataCollectionItem(arg0_10, arg1_10)
	return {
		trackType = var0_0.TYPE_DORM_COLLECTION_ITEM,
		args = {
			arg0_10,
			arg1_10,
			Count = 2
		}
	}
end

function var0_0.BuildDataStory(arg0_11, arg1_11)
	return {
		trackType = var0_0.TYPE_DORM_STORY,
		args = {
			arg0_11,
			Count = 1
		},
		strs = {
			arg1_11,
			Count = 1
		}
	}
end

function var0_0.BuildCameraMsg(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12, arg5_12, arg6_12)
	return table.concat(_.map({
		arg0_12,
		arg1_12,
		arg2_12,
		arg3_12,
		arg4_12,
		arg5_12,
		arg6_12
	}, function(arg0_13)
		return tostring(arg0_13)
	end), "_")
end

function var0_0.BuildDataCamera(arg0_14, arg1_14, arg2_14)
	return {
		trackType = var0_0.TYPE_DORM_CAMERA,
		args = {
			arg0_14,
			arg1_14,
			Count = 2
		},
		strs = {
			arg2_14,
			Count = 1
		}
	}
end

function var0_0.BuildDataCover(arg0_15, arg1_15)
	return {
		trackType = var0_0.TYPE_DORM_COVER,
		args = {
			arg0_15,
			arg1_15,
			Count = 2
		}
	}
end

function var0_0.BuildDataDownload(arg0_16, arg1_16)
	return {
		trackType = var0_0.TYPE_DORM_DOWNLOAD,
		args = {
			arg0_16,
			arg1_16,
			Count = 2
		}
	}
end

function var0_0.BuildDataIKFurniture(arg0_17, arg1_17)
	return {
		trackType = var0_0.TYPE_DORM_IK_FURNITURE,
		args = {
			arg0_17,
			arg1_17,
			Count = 2
		}
	}
end

function var0_0.BuildDataRoom(arg0_18, arg1_18, arg2_18, arg3_18)
	return {
		trackType = var0_0.TYPE_DORM_ROOM,
		args = {
			arg0_18,
			arg1_18,
			Count = 2
		},
		strs = {
			arg2_18,
			arg3_18,
			Count = 2
		}
	}
end

function var0_0.BuildDataAccompany(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	return {
		trackType = var0_0.TYPE_DORM_ACCOMPANY,
		args = {
			arg0_19,
			arg1_19,
			arg2_19,
			arg3_19,
			Count = 4
		},
		strs = {
			arg4_19,
			Count = 1
		}
	}
end

function var0_0.BuildDataMiniGame(arg0_20, arg1_20)
	return {
		trackType = var0_0.TYPE_DORM_MINIGAME,
		args = {
			arg0_20,
			arg1_20,
			Count = 2
		}
	}
end

function var0_0.BuildDataGuide(arg0_21, arg1_21)
	return {
		trackType = var0_0.TYPE_DORM_GUIDE,
		args = {
			arg0_21,
			Count = 1
		},
		strs = {
			tostring(arg1_21),
			Count = 1
		}
	}
end

function var0_0.BuildDataGraphics(arg0_22)
	local var0_22 = SystemInfo.deviceModel

	return {
		trackType = var0_0.TYPE_DORM_GRAPHICS,
		args = {
			arg0_22,
			Count = 1
		},
		strs = {
			var0_22,
			Count = 1
		}
	}
end

return var0_0
