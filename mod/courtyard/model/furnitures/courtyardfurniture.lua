local var0 = class("CourtYardFurniture", import("..map.CourtYardDepthItem"))

var0.STATE_IDLE = 1
var0.STATE_DRAG = 2
var0.STATE_INTERACT = 3
var0.STATE_TOUCH_PREPARE = 4
var0.STATE_TOUCH = 5
var0.STATE_PLAY_MUSIC = 6
var0.STATE_STOP_MUSIC = 7

function var0.Ctor(arg0, arg1, arg2)
	arg0.id = arg2.id
	arg0.configId = arg2.configId or arg0.id
	arg0.config = pg.furniture_data_template[arg0.configId]
	arg0.date = arg2.date or 0
	arg0.selectedFlag = false
	arg0.slots = {}

	arg0:InitSlots()

	arg0.musicDatas = {}
	arg0.musicData = nil

	arg0:InitMusicData()

	arg0.state = var0.STATE_IDLE

	var0.super.Ctor(arg0, arg1, arg0.id, arg0.config.size[1], arg0.config.size[2])
end

function var0.InitSlots(arg0)
	if arg0:IsSpine() then
		table.insert(arg0.slots, CourtYardFurnitureSpineSlot.New(1, arg0.config.spine))

		if type(arg0.config.spine_extra) == "table" then
			for iter0, iter1 in ipairs(arg0.config.spine_extra) do
				local var0 = {
					{},
					[3] = arg0.config.spine[3],
					[4] = iter1[1],
					[5] = iter1[2],
					[6] = iter1[3]
				}

				table.insert(arg0.slots, CourtYardFurnitureSpineSlot.New(iter0 + 1, var0))
			end
		end

		if type(arg0.config.followBone) == "table" then
			if type(arg0.config.followBone[1]) == "table" then
				for iter2, iter3 in ipairs(arg0.config.followBone) do
					local var1 = arg0.slots[iter2]

					if var1 then
						var1:SetFollower(iter3)
					end
				end
			elseif type(arg0.config.followBone[1]) == "string" then
				arg0.slots[1]:SetFollower(arg0.config.followBone)
			end
		elseif type(arg0.config.animator) == "table" then
			for iter4, iter5 in ipairs(arg0.slots) do
				iter5:SetAnimators(arg0.config.animator)
			end
		end

		if type(arg0.config.spine_action_replace) == "table" then
			for iter6, iter7 in ipairs(arg0.slots) do
				iter7:SetSubstitute(arg0.config.spine_action_replace)
			end
		end
	elseif type(arg0.config.interAction) == "table" then
		for iter8, iter9 in ipairs(arg0.config.interAction) do
			table.insert(arg0.slots, CourtYardFurnitureSlot.New(iter8, iter9))
		end
	end
end

function var0.GetLevel(arg0)
	return arg0.config.level
end

function var0._InitMusicData(arg0, arg1, arg2, arg3, arg4)
	local var0 = type(arg2) == "table" and arg2 or {
		arg2
	}
	local var1 = type(arg3) == "table" and arg3 or {
		arg3
	}

	for iter0, iter1 in ipairs(var0) do
		table.insert(arg0.musicDatas, {
			voice = iter1,
			voiceType = arg1,
			action = var1[iter0],
			effect = arg4
		})
	end
end

function var0.InitMusicData(arg0)
	local var0 = arg0.config.can_trigger

	if var0[1] == 3 then
		arg0:_InitMusicData(1, var0[2][1], var0[2][2], var0[2][3])
		arg0:_InitMusicData(2, var0[3][1], var0[3][2], var0[3][3])
	else
		arg0:_InitMusicData(var0[1], var0[2], var0[3], var0[4])
	end
end

function var0.Init(arg0, arg1, arg2)
	arg0:SetPosition(arg1)
	arg0:SetDir(arg2)
end

function var0.DisableRotation(arg0)
	return arg0.config.can_rotate ~= 0 or arg0:IsType(Furniture.TYPE_WALL) or arg0:IsType(Furniture.TYPE_WALL_MAT)
end

function var0.IsType(arg0, arg1)
	return arg0.config.type == arg1
end

function var0.IsMusicalInstruments(arg0)
	return arg0:IsType(Furniture.TYPE_LUTE)
end

function var0.IsRandomSlotType(arg0)
	return arg0:IsType(Furniture.TYPE_RANDOM_SLOT)
end

function var0.RawGetOffset(arg0)
	local var0 = arg0.config.offset

	return Vector3(var0[1], var0[2], 0)
end

function var0.SetPosition(arg0, arg1)
	var0.super.SetPosition(arg0, arg1)
	arg0:DispatchEvent(CourtYardEvent.FURNITURE_POSITION_CHANGE, arg1, arg0:GetOffset())
end

function var0.UpdateOpFlag(arg0, arg1)
	var0.super.UpdateOpFlag(arg0, arg1)
	arg0:DispatchEvent(CourtYardEvent.FURNITURE_OP_FLAG_CHANGE, arg0.opFlag)
end

function var0.InActivityRange(arg0, arg1)
	local var0 = arg0:GetHost():GetStorey():GetRange()

	return arg1.x < var0.x and arg1.y < var0.y and arg1.x >= 0 and arg1.y >= 0
end

function var0.GetObjType(arg0)
	return CourtYardConst.OBJ_TYPE_COMMOM
end

function var0.GetDeathType(arg0)
	return CourtYardConst.DEPTH_TYPE_FURNITURE
end

function var0.GetType(arg0)
	return arg0.config.type
end

function var0.GetPicture(arg0)
	return arg0.config.picture
end

function var0.IsOverlap(arg0, arg1)
	local var0 = arg0:GetArea()

	return _.any(var0, function(arg0)
		return arg0 == arg1
	end)
end

function var0.Rotate(arg0)
	local var0 = arg0.dir == 1 and 2 or 1

	var0.super.SetDir(arg0, var0)
	arg0:DispatchEvent(CourtYardEvent.ROTATE_FURNITURE, arg0.dir)
end

function var0.GetSize(arg0)
	return arg0.sizeX, arg0.sizeY
end

function var0.GetArchMask(arg0)
	return arg0.config.picture .. "_using"
end

function var0.HasDescription(arg0)
	local var0 = arg0.config.can_trigger

	return #var0 > 0 and var0[1] > 0
end

function var0.ExistVoice(arg0)
	local var0 = arg0.config.can_trigger

	return var0[2] ~= nil, var0[1]
end

function var0.GetIcon(arg0)
	return arg0.config.icon
end

function var0.GetName(arg0)
	return arg0.config.name
end

function var0.GetAddDate(arg0)
	if arg0.date > 0 then
		return pg.TimeMgr.GetInstance():STimeDescS(arg0.date, "%Y/%m/%d")
	end
end

function var0.GetComfortable(arg0)
	return arg0.config.comfortable
end

function var0.GetDescription(arg0)
	return arg0.config.describe
end

function var0.GetAddMode(arg0)
	return arg0.config.gain_by
end

function var0.GetGametipType(arg0)
	local var0 = arg0:GetType()

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
	})[var0]
end

function var0.CanTouch(arg0)
	return arg0.config.spine and arg0.config.spine[1] and arg0.config.spine[1][3] ~= nil
end

function var0.GetTouchAction(arg0)
	if arg0:CanTouch() then
		local var0 = arg0.config.spine
		local var1 = {}

		table.insert(var1, var0[1][3][1])

		for iter0, iter1 in ipairs(var0[1][3][3] or {}) do
			table.insert(var1, iter1)
		end

		return var1[math.random(1, #var1)], var0[1][3][2]
	end
end

function var0.GetTouchPrepareAction(arg0)
	if arg0:CanTouch() then
		return arg0.config.spine[1][3][6]
	end
end

function var0.GetTouchBg(arg0)
	if arg0:CanTouch() then
		return arg0.config.spine[1][3][7]
	end
end

function var0.TriggerTouchDefault(arg0)
	if arg0:CanTouch() and arg0.config.spine[1][3][8] and arg0.config.spine[1][3][8] > 0 then
		return true
	end

	return false
end

function var0.GetTouchSound(arg0)
	if arg0:CanTouch() then
		local var0 = arg0.config.spine[1][3][4]

		if type(var0) == "table" then
			return var0[math.random(1, #var0)]
		else
			return var0
		end
	end
end

function var0.GetTouchEffect(arg0)
	if arg0:CanTouch() then
		return arg0.config.spine[1][3][5]
	end
end

function var0.IsTouchState(arg0)
	return arg0.state == var0.STATE_TOUCH or arg0.state == var0.STATE_TOUCH_PREPARE
end

function var0.IsDragingState(arg0)
	return arg0.state == var0.STATE_DRAG
end

function var0.IsSpine(arg0)
	return type(arg0.config.spine) == "table"
end

function var0.GetFirstSlot(arg0)
	return arg0.slots[1]
end

function var0.AnySlotIsLoop(arg0)
	for iter0, iter1 in pairs(arg0.slots) do
		if iter1.loop then
			return true
		end
	end

	return false
end

function var0.GetMaskNames(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.slots) do
		local var1 = iter1:GetMask()

		if var1 then
			var0[iter1.id] = var1
		end
	end

	return var0
end

function var0.IsMultiMask(arg0)
	local var0 = arg0:GetMaskNames()

	return not arg0:IsSpine() and table.getCount(var0) > 0 and arg0:GetSlotCnt() > 1
end

function var0.GetBodyMasks(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.slots) do
		local var1 = iter1:GetBodyMask()

		if var1 then
			var0[iter1.id] = var1
		end
	end

	return var0
end

function var0.GetAnimators(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.slots) do
		for iter2, iter3 in pairs(iter1:GetAnimators()) do
			table.insert(var0, iter3)
		end
	end

	return var0
end

function var0.GetAnimatorMask(arg0)
	if not arg0.config.animator then
		return nil
	end

	local var0 = arg0.config.animator[3]

	if var0 then
		return {
			size = Vector2(var0[1][1], var0[1][2]),
			offset = Vector2(var0[2][1], var0[2][2])
		}
	end
end

function var0.CanInterAction(arg0, arg1)
	return _.any(arg0.slots, function(arg0)
		return arg0:IsEmpty()
	end) and not arg0:IsPlayMusicState() and (#arg0.config.interAction_group == 0 or _.any(arg0.config.interAction_group, function(arg0)
		return arg1:GetGroupID() == arg0
	end))
end

function var0.IsPlayMusicState(arg0)
	return arg0.state == var0.STATE_PLAY_MUSIC
end

function var0.GetInteractionSlot(arg0)
	if arg0:IsRandomSlotType() then
		local var0 = {}

		for iter0, iter1 in ipairs(arg0.slots) do
			if iter1:IsEmpty() then
				table.insert(var0, iter1)
			end
		end

		return var0[math.random(1, #var0)]
	else
		return _.detect(arg0.slots, function(arg0)
			return arg0:IsEmpty()
		end)
	end
end

function var0._ChangeState(arg0, arg1)
	arg0.state = arg1

	arg0:DispatchEvent(CourtYardEvent.FURNITURE_STATE_CHANGE, arg1)
end

function var0.ChangeState(arg0, arg1)
	if arg0:IsPlayMusicState() and arg1 ~= var0.STATE_STOP_MUSIC then
		return
	end

	if arg0:IsInteractionState() then
		return
	end

	if arg1 == var0.STATE_TOUCH and arg0:GetTouchPrepareAction() then
		arg0:_ChangeState(var0.STATE_TOUCH_PREPARE)
	elseif arg1 == var0.STATE_PLAY_MUSIC then
		local var0 = _.select(arg0.musicDatas, function(arg0)
			return arg0.voiceType == 2
		end)

		if #var0 > 0 then
			arg0.musicData = var0[math.random(1, #var0)]

			arg0:_ChangeState(arg1)
		end
	elseif arg1 == var0.STATE_STOP_MUSIC then
		arg0:_ChangeState(var0.STATE_IDLE)

		arg0.musicData = nil
	else
		arg0:_ChangeState(arg1)
	end
end

function var0.IsInteractionState(arg0)
	return arg0.state == var0.STATE_INTERACT
end

function var0.WillInteraction(arg0, arg1)
	arg0:DispatchEvent(CourtYardEvent.FURNITURE_WILL_INTERACTION, arg1)
end

function var0.StartInteraction(arg0, arg1)
	local var0 = {}

	_.each(arg0.slots, function(arg0)
		if arg0.id ~= arg1.id and arg0:IsUsing() then
			table.insert(var0, arg0)
			arg0:DispatchEvent(CourtYardEvent.FURNITURE_STOP_INTERACTION, arg0)
		end
	end)

	if #var0 > 0 then
		arg0:_ChangeState(var0.STATE_IDLE)
	end

	arg0:_ChangeState(var0.STATE_INTERACT)

	if #var0 > 0 then
		arg1:OnStart()
	end

	for iter0, iter1 in ipairs(var0) do
		iter1:OnStart()
		arg0:DispatchEvent(CourtYardEvent.FURNITURE_START_INTERACTION, iter1)
	end

	arg0:DispatchEvent(CourtYardEvent.FURNITURE_START_INTERACTION, arg1)
end

function var0.OnPreheatActionEnd(arg0)
	return
end

function var0.UpdateInteraction(arg0, ...)
	arg0:DispatchEvent(CourtYardEvent.FURNITURE_UPDATE_INTERACTION, ...)
end

function var0.AnySlotIsUsing(arg0)
	return _.any(arg0.slots, function(arg0)
		return arg0:IsUsing()
	end)
end

function var0.ClearInteraction(arg0, arg1)
	local var0 = _.select(arg0.slots, function(arg0)
		return arg0.id ~= arg1.id and arg0:IsUsing()
	end)

	for iter0, iter1 in ipairs(var0) do
		iter1:Reset()
	end

	if #var0 <= 0 then
		arg0:_ChangeState(var0.STATE_IDLE)
	end

	onNextTick(function()
		arg0:DispatchEvent(CourtYardEvent.FURNITURE_STOP_INTERACTION, arg1)
	end)
end

function var0.GetUsingSlots(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.slots) do
		if iter1:IsUsing() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.GetSlotCnt(arg0)
	return #arg0.slots
end

function var0.GetMusicData(arg0)
	return arg0.musicData
end

function var0.GetInterActionBgm(arg0)
	local var0 = type(arg0.config.interaction_bgm)

	if var0 == "string" then
		return arg0.config.interaction_bgm, 0
	elseif var0 == "table" then
		return arg0.config.interaction_bgm[2], arg0.config.interaction_bgm[1]
	else
		return nil
	end
end

function var0.CanClickWhenExitEditMode(arg0)
	return arg0:HasDescription() or arg0:CanTouch()
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)

	for iter0, iter1 in ipairs(arg0:GetUsingSlots()) do
		iter1:Stop()
	end
end

function var0.ToTable(arg0)
	local var0 = arg0:GetPosition()

	return {
		id = arg0.id,
		configId = arg0.configId,
		dir = arg0.dir,
		position = var0,
		x = var0.x,
		y = var0.y,
		parent = arg0.parent and arg0.parent.id or 0,
		child = {}
	}
end

return var0
