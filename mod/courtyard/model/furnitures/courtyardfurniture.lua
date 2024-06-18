local var0_0 = class("CourtYardFurniture", import("..map.CourtYardDepthItem"))

var0_0.STATE_IDLE = 1
var0_0.STATE_DRAG = 2
var0_0.STATE_INTERACT = 3
var0_0.STATE_TOUCH_PREPARE = 4
var0_0.STATE_TOUCH = 5
var0_0.STATE_PLAY_MUSIC = 6
var0_0.STATE_STOP_MUSIC = 7

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg2_1.id
	arg0_1.configId = arg2_1.configId or arg0_1.id
	arg0_1.config = pg.furniture_data_template[arg0_1.configId]
	arg0_1.date = arg2_1.date or 0
	arg0_1.selectedFlag = false
	arg0_1.slots = {}

	arg0_1:InitSlots()

	arg0_1.musicDatas = {}
	arg0_1.musicData = nil

	arg0_1:InitMusicData()

	arg0_1.state = var0_0.STATE_IDLE

	var0_0.super.Ctor(arg0_1, arg1_1, arg0_1.id, arg0_1.config.size[1], arg0_1.config.size[2])
end

function var0_0.InitSlots(arg0_2)
	if arg0_2:IsSpine() then
		table.insert(arg0_2.slots, CourtYardFurnitureSpineSlot.New(1, arg0_2.config.spine))

		if type(arg0_2.config.spine_extra) == "table" then
			for iter0_2, iter1_2 in ipairs(arg0_2.config.spine_extra) do
				local var0_2 = {
					{},
					[3] = arg0_2.config.spine[3],
					[4] = iter1_2[1],
					[5] = iter1_2[2],
					[6] = iter1_2[3]
				}

				table.insert(arg0_2.slots, CourtYardFurnitureSpineSlot.New(iter0_2 + 1, var0_2))
			end
		end

		if type(arg0_2.config.followBone) == "table" then
			if type(arg0_2.config.followBone[1]) == "table" then
				for iter2_2, iter3_2 in ipairs(arg0_2.config.followBone) do
					local var1_2 = arg0_2.slots[iter2_2]

					if var1_2 then
						var1_2:SetFollower(iter3_2)
					end
				end
			elseif type(arg0_2.config.followBone[1]) == "string" then
				arg0_2.slots[1]:SetFollower(arg0_2.config.followBone)
			end
		elseif type(arg0_2.config.animator) == "table" then
			for iter4_2, iter5_2 in ipairs(arg0_2.slots) do
				iter5_2:SetAnimators(arg0_2.config.animator)
			end
		end

		if type(arg0_2.config.spine_action_replace) == "table" then
			for iter6_2, iter7_2 in ipairs(arg0_2.slots) do
				iter7_2:SetSubstitute(arg0_2.config.spine_action_replace)
			end
		end
	elseif type(arg0_2.config.interAction) == "table" then
		for iter8_2, iter9_2 in ipairs(arg0_2.config.interAction) do
			table.insert(arg0_2.slots, CourtYardFurnitureSlot.New(iter8_2, iter9_2))
		end
	end
end

function var0_0.GetLevel(arg0_3)
	return arg0_3.config.level
end

function var0_0._InitMusicData(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	local var0_4 = type(arg2_4) == "table" and arg2_4 or {
		arg2_4
	}
	local var1_4 = type(arg3_4) == "table" and arg3_4 or {
		arg3_4
	}

	for iter0_4, iter1_4 in ipairs(var0_4) do
		table.insert(arg0_4.musicDatas, {
			voice = iter1_4,
			voiceType = arg1_4,
			action = var1_4[iter0_4],
			effect = arg4_4
		})
	end
end

function var0_0.InitMusicData(arg0_5)
	local var0_5 = arg0_5.config.can_trigger

	if var0_5[1] == 3 then
		arg0_5:_InitMusicData(1, var0_5[2][1], var0_5[2][2], var0_5[2][3])
		arg0_5:_InitMusicData(2, var0_5[3][1], var0_5[3][2], var0_5[3][3])
	else
		arg0_5:_InitMusicData(var0_5[1], var0_5[2], var0_5[3], var0_5[4])
	end
end

function var0_0.Init(arg0_6, arg1_6, arg2_6)
	arg0_6:SetPosition(arg1_6)
	arg0_6:SetDir(arg2_6)
end

function var0_0.DisableRotation(arg0_7)
	return arg0_7.config.can_rotate ~= 0 or arg0_7:IsType(Furniture.TYPE_WALL) or arg0_7:IsType(Furniture.TYPE_WALL_MAT)
end

function var0_0.IsType(arg0_8, arg1_8)
	return arg0_8.config.type == arg1_8
end

function var0_0.IsMusicalInstruments(arg0_9)
	return arg0_9:IsType(Furniture.TYPE_LUTE)
end

function var0_0.IsRandomSlotType(arg0_10)
	return arg0_10:IsType(Furniture.TYPE_RANDOM_SLOT)
end

function var0_0.RawGetOffset(arg0_11)
	local var0_11 = arg0_11.config.offset

	return Vector3(var0_11[1], var0_11[2], 0)
end

function var0_0.SetPosition(arg0_12, arg1_12)
	var0_0.super.SetPosition(arg0_12, arg1_12)
	arg0_12:DispatchEvent(CourtYardEvent.FURNITURE_POSITION_CHANGE, arg1_12, arg0_12:GetOffset())
end

function var0_0.UpdateOpFlag(arg0_13, arg1_13)
	var0_0.super.UpdateOpFlag(arg0_13, arg1_13)
	arg0_13:DispatchEvent(CourtYardEvent.FURNITURE_OP_FLAG_CHANGE, arg0_13.opFlag)
end

function var0_0.InActivityRange(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetHost():GetStorey():GetRange()

	return arg1_14.x < var0_14.x and arg1_14.y < var0_14.y and arg1_14.x >= 0 and arg1_14.y >= 0
end

function var0_0.GetObjType(arg0_15)
	return CourtYardConst.OBJ_TYPE_COMMOM
end

function var0_0.GetDeathType(arg0_16)
	return CourtYardConst.DEPTH_TYPE_FURNITURE
end

function var0_0.GetType(arg0_17)
	return arg0_17.config.type
end

function var0_0.GetPicture(arg0_18)
	return arg0_18.config.picture
end

function var0_0.IsOverlap(arg0_19, arg1_19)
	local var0_19 = arg0_19:GetArea()

	return _.any(var0_19, function(arg0_20)
		return arg0_20 == arg1_19
	end)
end

function var0_0.Rotate(arg0_21)
	local var0_21 = arg0_21.dir == 1 and 2 or 1

	var0_0.super.SetDir(arg0_21, var0_21)
	arg0_21:DispatchEvent(CourtYardEvent.ROTATE_FURNITURE, arg0_21.dir)
end

function var0_0.GetSize(arg0_22)
	return arg0_22.sizeX, arg0_22.sizeY
end

function var0_0.GetArchMask(arg0_23)
	return arg0_23.config.picture .. "_using"
end

function var0_0.HasDescription(arg0_24)
	local var0_24 = arg0_24.config.can_trigger

	return #var0_24 > 0 and var0_24[1] > 0
end

function var0_0.ExistVoice(arg0_25)
	local var0_25 = arg0_25.config.can_trigger

	return var0_25[2] ~= nil, var0_25[1]
end

function var0_0.GetIcon(arg0_26)
	return arg0_26.config.icon
end

function var0_0.GetName(arg0_27)
	return arg0_27.config.name
end

function var0_0.GetAddDate(arg0_28)
	if arg0_28.date > 0 then
		return pg.TimeMgr.GetInstance():STimeDescS(arg0_28.date, "%Y/%m/%d")
	end
end

function var0_0.GetComfortable(arg0_29)
	return arg0_29.config.comfortable
end

function var0_0.GetDescription(arg0_30)
	return arg0_30.config.describe
end

function var0_0.GetAddMode(arg0_31)
	return arg0_31.config.gain_by
end

function var0_0.GetGametipType(arg0_32)
	local var0_32 = arg0_32:GetType()

	return ({
		i18n("word_wallpaper"),
		i18n("word_furniture"),
		i18n("word_decorate"),
		i18n("word_floorpaper"),
		i18n("word_mat"),
		i18n("word_wall"),
		i18n("word_collection"),
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		i18n("word_collection")
	})[var0_32]
end

function var0_0.CanTouch(arg0_33)
	return arg0_33.config.spine and arg0_33.config.spine[1] and arg0_33.config.spine[1][3] ~= nil
end

function var0_0.GetTouchAction(arg0_34)
	if arg0_34:CanTouch() then
		local var0_34 = arg0_34.config.spine
		local var1_34 = {}

		table.insert(var1_34, var0_34[1][3][1])

		for iter0_34, iter1_34 in ipairs(var0_34[1][3][3] or {}) do
			table.insert(var1_34, iter1_34)
		end

		return var1_34[math.random(1, #var1_34)], var0_34[1][3][2]
	end
end

function var0_0.GetTouchPrepareAction(arg0_35)
	if arg0_35:CanTouch() then
		return arg0_35.config.spine[1][3][6]
	end
end

function var0_0.GetTouchBg(arg0_36)
	if arg0_36:CanTouch() then
		return arg0_36.config.spine[1][3][7]
	end
end

function var0_0.TriggerTouchDefault(arg0_37)
	if arg0_37:CanTouch() and arg0_37.config.spine[1][3][8] and arg0_37.config.spine[1][3][8] > 0 then
		return true
	end

	return false
end

function var0_0.GetTouchSound(arg0_38)
	if arg0_38:CanTouch() then
		local var0_38 = arg0_38.config.spine[1][3][4]

		if type(var0_38) == "table" then
			return var0_38[math.random(1, #var0_38)]
		else
			return var0_38
		end
	end
end

function var0_0.GetTouchEffect(arg0_39)
	if arg0_39:CanTouch() then
		return arg0_39.config.spine[1][3][5]
	end
end

function var0_0.IsTouchState(arg0_40)
	return arg0_40.state == var0_0.STATE_TOUCH or arg0_40.state == var0_0.STATE_TOUCH_PREPARE
end

function var0_0.IsDragingState(arg0_41)
	return arg0_41.state == var0_0.STATE_DRAG
end

function var0_0.IsSpine(arg0_42)
	return type(arg0_42.config.spine) == "table"
end

function var0_0.GetFirstSlot(arg0_43)
	return arg0_43.slots[1]
end

function var0_0.AnySlotIsLoop(arg0_44)
	for iter0_44, iter1_44 in pairs(arg0_44.slots) do
		if iter1_44.loop then
			return true
		end
	end

	return false
end

function var0_0.GetMaskNames(arg0_45)
	local var0_45 = {}

	for iter0_45, iter1_45 in ipairs(arg0_45.slots) do
		local var1_45 = iter1_45:GetMask()

		if var1_45 then
			var0_45[iter1_45.id] = var1_45
		end
	end

	return var0_45
end

function var0_0.IsMultiMask(arg0_46)
	local var0_46 = arg0_46:GetMaskNames()

	return not arg0_46:IsSpine() and table.getCount(var0_46) > 0 and arg0_46:GetSlotCnt() > 1
end

function var0_0.GetBodyMasks(arg0_47)
	local var0_47 = {}

	for iter0_47, iter1_47 in ipairs(arg0_47.slots) do
		local var1_47 = iter1_47:GetBodyMask()

		if var1_47 then
			var0_47[iter1_47.id] = var1_47
		end
	end

	return var0_47
end

function var0_0.GetAnimators(arg0_48)
	local var0_48 = {}

	for iter0_48, iter1_48 in ipairs(arg0_48.slots) do
		for iter2_48, iter3_48 in pairs(iter1_48:GetAnimators()) do
			table.insert(var0_48, iter3_48)
		end
	end

	return var0_48
end

function var0_0.GetAnimatorMask(arg0_49)
	if not arg0_49.config.animator then
		return nil
	end

	local var0_49 = arg0_49.config.animator[3]

	if var0_49 then
		return {
			size = Vector2(var0_49[1][1], var0_49[1][2]),
			offset = Vector2(var0_49[2][1], var0_49[2][2])
		}
	end
end

function var0_0.CanInterAction(arg0_50, arg1_50)
	return _.any(arg0_50.slots, function(arg0_51)
		return arg0_51:IsEmpty()
	end) and not arg0_50:IsPlayMusicState() and (#arg0_50.config.interAction_group == 0 or _.any(arg0_50.config.interAction_group, function(arg0_52)
		return arg1_50:GetGroupID() == arg0_52
	end))
end

function var0_0.IsPlayMusicState(arg0_53)
	return arg0_53.state == var0_0.STATE_PLAY_MUSIC
end

function var0_0.GetInteractionSlot(arg0_54)
	if arg0_54:IsRandomSlotType() then
		local var0_54 = {}

		for iter0_54, iter1_54 in ipairs(arg0_54.slots) do
			if iter1_54:IsEmpty() then
				table.insert(var0_54, iter1_54)
			end
		end

		return var0_54[math.random(1, #var0_54)]
	else
		return _.detect(arg0_54.slots, function(arg0_55)
			return arg0_55:IsEmpty()
		end)
	end
end

function var0_0._ChangeState(arg0_56, arg1_56)
	arg0_56.state = arg1_56

	arg0_56:DispatchEvent(CourtYardEvent.FURNITURE_STATE_CHANGE, arg1_56)
end

function var0_0.ChangeState(arg0_57, arg1_57)
	if arg0_57:IsPlayMusicState() and arg1_57 ~= var0_0.STATE_STOP_MUSIC then
		return
	end

	if arg0_57:IsInteractionState() then
		return
	end

	if arg1_57 == var0_0.STATE_TOUCH and arg0_57:GetTouchPrepareAction() then
		arg0_57:_ChangeState(var0_0.STATE_TOUCH_PREPARE)
	elseif arg1_57 == var0_0.STATE_PLAY_MUSIC then
		local var0_57 = _.select(arg0_57.musicDatas, function(arg0_58)
			return arg0_58.voiceType == 2
		end)

		if #var0_57 > 0 then
			arg0_57.musicData = var0_57[math.random(1, #var0_57)]

			arg0_57:_ChangeState(arg1_57)
		end
	elseif arg1_57 == var0_0.STATE_STOP_MUSIC then
		arg0_57:_ChangeState(var0_0.STATE_IDLE)

		arg0_57.musicData = nil
	else
		arg0_57:_ChangeState(arg1_57)
	end
end

function var0_0.IsInteractionState(arg0_59)
	return arg0_59.state == var0_0.STATE_INTERACT
end

function var0_0.WillInteraction(arg0_60, arg1_60)
	arg0_60:DispatchEvent(CourtYardEvent.FURNITURE_WILL_INTERACTION, arg1_60)
end

function var0_0.StartInteraction(arg0_61, arg1_61)
	local var0_61 = {}

	_.each(arg0_61.slots, function(arg0_62)
		if arg0_62.id ~= arg1_61.id and arg0_62:IsUsing() then
			table.insert(var0_61, arg0_62)
			arg0_61:DispatchEvent(CourtYardEvent.FURNITURE_STOP_INTERACTION, arg0_62)
		end
	end)

	if #var0_61 > 0 then
		arg0_61:_ChangeState(var0_0.STATE_IDLE)
	end

	arg0_61:_ChangeState(var0_0.STATE_INTERACT)

	if #var0_61 > 0 then
		arg1_61:OnStart()
	end

	for iter0_61, iter1_61 in ipairs(var0_61) do
		iter1_61:OnStart()
		arg0_61:DispatchEvent(CourtYardEvent.FURNITURE_START_INTERACTION, iter1_61)
	end

	arg0_61:DispatchEvent(CourtYardEvent.FURNITURE_START_INTERACTION, arg1_61)
end

function var0_0.OnPreheatActionEnd(arg0_63)
	return
end

function var0_0.UpdateInteraction(arg0_64, ...)
	arg0_64:DispatchEvent(CourtYardEvent.FURNITURE_UPDATE_INTERACTION, ...)
end

function var0_0.AnySlotIsUsing(arg0_65)
	return _.any(arg0_65.slots, function(arg0_66)
		return arg0_66:IsUsing()
	end)
end

function var0_0.ClearInteraction(arg0_67, arg1_67)
	local var0_67 = _.select(arg0_67.slots, function(arg0_68)
		return arg0_68.id ~= arg1_67.id and arg0_68:IsUsing()
	end)

	for iter0_67, iter1_67 in ipairs(var0_67) do
		iter1_67:Reset()
	end

	if #var0_67 <= 0 then
		arg0_67:_ChangeState(var0_0.STATE_IDLE)
	end

	onNextTick(function()
		arg0_67:DispatchEvent(CourtYardEvent.FURNITURE_STOP_INTERACTION, arg1_67)
	end)
end

function var0_0.GetUsingSlots(arg0_70)
	local var0_70 = {}

	for iter0_70, iter1_70 in ipairs(arg0_70.slots) do
		if iter1_70:IsUsing() then
			table.insert(var0_70, iter1_70)
		end
	end

	return var0_70
end

function var0_0.GetSlotCnt(arg0_71)
	return #arg0_71.slots
end

function var0_0.GetMusicData(arg0_72)
	return arg0_72.musicData
end

function var0_0.GetInterActionBgm(arg0_73)
	local var0_73 = type(arg0_73.config.interaction_bgm)

	if var0_73 == "string" then
		return arg0_73.config.interaction_bgm, 0
	elseif var0_73 == "table" then
		return arg0_73.config.interaction_bgm[2], arg0_73.config.interaction_bgm[1]
	else
		return nil
	end
end

function var0_0.CanClickWhenExitEditMode(arg0_74)
	return arg0_74:HasDescription() or arg0_74:CanTouch()
end

function var0_0.Dispose(arg0_75)
	var0_0.super.Dispose(arg0_75)

	for iter0_75, iter1_75 in ipairs(arg0_75:GetUsingSlots()) do
		iter1_75:Stop()
	end
end

function var0_0.ToTable(arg0_76)
	local var0_76 = arg0_76:GetPosition()

	return {
		id = arg0_76.id,
		configId = arg0_76.configId,
		dir = arg0_76.dir,
		position = var0_76,
		x = var0_76.x,
		y = var0_76.y,
		parent = arg0_76.parent and arg0_76.parent.id or 0,
		child = {}
	}
end

return var0_0
