local var0_0 = class("DialogueStep", import(".StoryStep"))

var0_0.SIDE_LEFT = 0
var0_0.SIDE_RIGHT = 1
var0_0.SIDE_MIDDLE = 2
var0_0.ACTOR_TYPE_PLAYER = 0
var0_0.ACTOR_TYPE_FLAGSHIP = -1
var0_0.ACTOR_TYPE_TB = -2
var0_0.PAINTING_ACTION_MOVE = "move"
var0_0.PAINTING_ACTION_SHAKE = "shake"
var0_0.PAINTING_ACTION_ZOOM = "zoom"
var0_0.PAINTING_ACTION_ROTATE = "rotate"

local var1_0 = pg.ship_skin_template

local function var2_0(arg0_1)
	local var0_1 = string.lower(arg0_1)

	if var0_1 == "#a9f548" or var0_1 == "#a9f548ff" then
		return "#5CE6FF"
	elseif var0_1 == "#ff5c5c" then
		return "#FF9B93"
	elseif var0_1 == "#ffa500" then
		return "#FFC960"
	elseif var0_1 == "#ffff4d" then
		return "#FEF15E"
	elseif var0_1 == "#696969" then
		return "#BDBDBD"
	elseif var0_1 == "#a020f0" then
		return "#C3ABFF"
	elseif var0_1 == "#ffffff" then
		return "#FFFFFF"
	else
		return arg0_1
	end
end

function var0_0.Ctor(arg0_2, arg1_2)
	var0_0.super.Ctor(arg0_2, arg1_2)

	arg0_2.actor = arg1_2.actor

	if arg1_2.nameColor then
		arg0_2.nameColor = var2_0(arg1_2.nameColor)
	else
		arg0_2.nameColor = COLOR_WHITE
	end

	arg0_2.specialTbId = nil

	if arg1_2.tbActor then
		arg0_2.specialTbId = arg0_2.actor
		arg0_2.actor = var0_0.ACTOR_TYPE_TB
	end

	arg0_2.actorName = arg1_2.actorName
	arg0_2.subActorName = arg1_2.factiontag
	arg0_2.subActorNameColor = arg1_2.factiontagColor or "#FFFFFF"
	arg0_2.withoutActorName = arg1_2.withoutActorName
	arg0_2.say = arg1_2.say
	arg0_2.dynamicBgType = arg1_2.dynamicBgType
	arg0_2.fontSize = arg1_2.fontsize
	arg0_2.side = arg1_2.side
	arg0_2.dir = arg1_2.dir

	if arg0_2.dir == 0 then
		arg0_2.dir = 1
	end

	arg0_2.expression = arg1_2.expression
	arg0_2.typewriter = arg1_2.typewriter
	arg0_2.painting = arg1_2.painting
	arg0_2.fadeInPaintingTime = arg1_2.fadeInPaintingTime or 0.15
	arg0_2.fadeOutPaintingTime = arg1_2.fadeOutPaintingTime or 0.15
	arg0_2.actorPosition = arg1_2.actorPosition
	arg0_2.dialogShake = arg1_2.dialogShake
	arg0_2.moveSideData = arg1_2.paintingFadeOut
	arg0_2.paingtingGray = arg1_2.paingtingGray
	arg0_2.glitchArt = arg1_2.paintingNoise
	arg0_2.hideOtherPainting = arg1_2.hideOther
	arg0_2.subPaintings = arg1_2.subActors
	arg0_2.disappearSeq = {}
	arg0_2.disappearTime = {
		0,
		0
	}

	if arg0_2.subPaintings and #arg0_2.subPaintings > 0 and arg1_2.disappearSeq then
		arg0_2.disappearSeq = arg1_2.disappearSeq
		arg0_2.disappearTime = arg1_2.disappearTime or {
			0,
			0
		}
	end

	arg0_2.hideRecordIco = arg1_2.hideRecordIco
	arg0_2.paingtingScale = arg1_2.actorScale
	arg0_2.hidePainting = arg1_2.withoutPainting
	arg0_2.actorShadow = arg1_2.actorShadow
	arg0_2.actorAlpha = arg1_2.actorAlpha
	arg0_2.showNPainting = arg1_2.hidePaintObj
	arg0_2.hasPaintbg = arg1_2.hasPaintbg
	arg0_2.showWJZPainting = arg1_2.hidePaintEquip
	arg0_2.nohead = arg1_2.nohead
	arg0_2.live2d = arg1_2.live2d
	arg0_2.live2dIdleIndex = arg1_2.live2dIdleIndex
	arg0_2.spine = arg1_2.spine
	arg0_2.spineOrderIndex = arg1_2.spineOrderIndex
	arg0_2.live2dOffset = arg1_2.live2dOffset
	arg0_2.contentBGAlpha = arg1_2.dialogueBgAlpha or 1
	arg0_2.canMarkNode = arg1_2.canMarkNode
	arg0_2.portrait = arg1_2.portrait
	arg0_2.glitchArtForPortrait = arg1_2.portraitNoise

	if arg0_2.hidePainting or arg0_2.actor == nil then
		arg0_2.actor = nil
		arg0_2.hideOtherPainting = true
	end

	arg0_2.paintRwIndex = arg1_2.paintRwIndex or 0
	arg0_2.action = arg1_2.action or {}
end

function var0_0.GetBgName(arg0_3)
	if arg0_3.dynamicBgType and arg0_3.dynamicBgType == var0_0.ACTOR_TYPE_TB and getProxy(EducateProxy) and not pg.NewStoryMgr.GetInstance():IsReView() then
		local var0_3, var1_3, var2_3 = getProxy(EducateProxy):GetStoryInfo()

		return (arg0_3:Convert2StoryBg(var2_3))
	else
		return var0_0.super.GetBgName(arg0_3)
	end
end

function var0_0.Convert2StoryBg(arg0_4, arg1_4)
	return ({
		educate_tb_1 = "bg_project_tb_room1",
		educate_tb_2 = "bg_project_tb_room2",
		educate_tb_3 = "bg_project_tb_room3"
	})[arg1_4] or arg1_4
end

function var0_0.GetPaintingRwIndex(arg0_5)
	if not arg0_5.glitchArt then
		return 0
	end

	if not arg0_5.expression then
		return 0
	end

	return arg0_5.paintRwIndex
end

function var0_0.ExistPortrait(arg0_6)
	return arg0_6.portrait ~= nil
end

function var0_0.GetPortrait(arg0_7)
	if type(arg0_7.portrait) == "number" then
		return pg.ship_skin_template[arg0_7.portrait].painting
	elseif type(arg0_7.portrait) == "string" then
		return arg0_7.portrait
	else
		return nil
	end
end

function var0_0.ShouldGlitchArtForPortrait(arg0_8)
	return arg0_8.glitchArtForPortrait
end

function var0_0.GetMode(arg0_9)
	return Story.MODE_DIALOGUE
end

function var0_0.GetContentBGAlpha(arg0_10)
	return arg0_10.contentBGAlpha
end

function var0_0.GetSpineExPression(arg0_11)
	if arg0_11.expression then
		return arg0_11.expression
	end
end

function var0_0.GetExPression(arg0_12)
	if arg0_12.expression then
		return arg0_12.expression
	else
		local var0_12 = arg0_12:GetPainting()

		if var0_12 and ShipExpressionHelper.DefaultFaceless(var0_12) then
			return ShipExpressionHelper.GetDefaultFace(var0_12)
		end
	end
end

function var0_0.ShouldAddHeadMaskWhenFade(arg0_13)
	if arg0_13:ShouldAddGlitchArtEffect() then
		return false
	end

	if arg0_13:IsNoHeadPainting() then
		return false
	end

	if not arg0_13:GetExPression() then
		return false
	end

	return true
end

function var0_0.ShouldGrayingPainting(arg0_14, arg1_14)
	return arg1_14:GetPainting() ~= nil and not arg0_14:IsSameSide(arg1_14)
end

function var0_0.ShouldGrayingOutPainting(arg0_15, arg1_15)
	return arg0_15:GetPainting() ~= nil and not arg0_15:IsSameSide(arg1_15)
end

function var0_0.ShouldFadeInPainting(arg0_16)
	if not arg0_16:GetPainting() then
		return false
	end

	if arg0_16:IsLive2dPainting() or arg0_16:IsSpinePainting() then
		return false
	end

	local var0_16 = arg0_16:GetFadeInPaintingTime()

	if not var0_16 or var0_16 <= 0 then
		return false
	end

	return true
end

function var0_0.GetTypewriter(arg0_17)
	return arg0_17.typewriter
end

function var0_0.ShouldFaceBlack(arg0_18)
	return arg0_18.actorShadow
end

function var0_0.GetPaintingData(arg0_19)
	local var0_19 = arg0_19.painting or {}

	return {
		alpha = var0_19.alpha or 0.3,
		time = var0_19.time or 1
	}
end

function var0_0.GetFadeInPaintingTime(arg0_20)
	return arg0_20.fadeInPaintingTime
end

function var0_0.GetFadeOutPaintingTime(arg0_21)
	return arg0_21.fadeOutPaintingTime
end

function var0_0.GetPaintingDir(arg0_22)
	local var0_22 = arg0_22.paingtingScale or 1

	return (arg0_22.dir or 1) * var0_22
end

function var0_0.GetTag(arg0_23)
	if arg0_23.glitchArt == true then
		return 2
	else
		return 1
	end
end

function var0_0.GetPaintingAlpha(arg0_24)
	return arg0_24.actorAlpha
end

function var0_0.GetPaitingOffst(arg0_25)
	return arg0_25.actorPosition
end

function var0_0.GetSound(arg0_26)
	return arg0_26.sound
end

function var0_0.GetPaintingActions(arg0_27)
	return arg0_27.action
end

function var0_0.GetPaintingMoveToSide(arg0_28)
	return arg0_28.moveSideData
end

function var0_0.ShouldMoveToSide(arg0_29)
	return arg0_29.moveSideData ~= nil
end

function var0_0.GetPaintingAction(arg0_30, arg1_30)
	local var0_30 = {}
	local var1_30 = arg0_30:GetPaintingActions()

	for iter0_30, iter1_30 in ipairs(var1_30) do
		if iter1_30.type == arg1_30 then
			table.insert(var0_30, iter1_30)
		end
	end

	return var0_30
end

function var0_0.GetSide(arg0_31)
	return arg0_31.side
end

function var0_0.GetContent(arg0_32)
	if not arg0_32.say then
		return "..."
	end

	local var0_32 = arg0_32.say

	if arg0_32:ShouldReplacePlayer() then
		var0_32 = arg0_32:ReplacePlayerName(var0_32)
	end

	if arg0_32:ShouldReplaceTb() then
		var0_32 = arg0_32:ReplaceTbName(var0_32)
	end

	if PLATFORM_CODE ~= PLATFORM_US then
		var0_32 = SwitchSpecialChar(HXSet.hxLan(var0_32), true)
	else
		var0_32 = HXSet.hxLan(var0_32)
	end

	return var0_32
end

function var0_0.GetNameWithColor(arg0_33)
	local var0_33 = arg0_33:GetName()

	if not var0_33 then
		return nil
	end

	local var1_33 = arg0_33:GetNameColor()

	return setColorStr(var0_33, var1_33)
end

function var0_0.GetNameColor(arg0_34)
	return arg0_34.nameColor or COLOR_WHITE
end

function var0_0.GetNameColorCode(arg0_35)
	local var0_35 = arg0_35:GetNameColor()

	return string.gsub(var0_35, "#", "")
end

function var0_0.GetCustomActorName(arg0_36)
	if type(arg0_36.actorName) == "number" and arg0_36.actorName == 0 and getProxy(PlayerProxy) then
		return getProxy(PlayerProxy):getRawData().name
	elseif type(arg0_36.actorName) == "string" then
		return arg0_36.actorName
	else
		return ""
	end
end

function var0_0.GetName(arg0_37)
	local var0_37 = arg0_37.actorName and arg0_37:GetCustomActorName() or arg0_37:GetPaintingAndName() or ""

	if not var0_37 or var0_37 == "" or arg0_37.withoutActorName then
		return nil
	end

	if arg0_37:ShouldReplacePlayer() then
		var0_37 = arg0_37:ReplacePlayerName(var0_37)
	end

	if arg0_37:ShouldReplaceTb() then
		var0_37 = arg0_37:ReplaceTbName(var0_37)
	end

	return (HXSet.hxLan(var0_37))
end

function var0_0.GetPainting(arg0_38)
	local var0_38, var1_38 = arg0_38:GetPaintingAndName()

	return var1_38
end

function var0_0.ExistPainting(arg0_39)
	return arg0_39:GetPainting() ~= nil
end

function var0_0.ShouldShakeDailogue(arg0_40)
	return arg0_40.dialogShake ~= nil
end

function var0_0.GetShakeDailogueData(arg0_41)
	return arg0_41.dialogShake
end

function var0_0.IsSameSide(arg0_42, arg1_42)
	local var0_42 = arg0_42:GetPrevSide(arg1_42)
	local var1_42 = arg0_42:GetSide()

	return var0_42 ~= nil and var1_42 ~= nil and var0_42 == var1_42
end

function var0_0.GetPrevSide(arg0_43, arg1_43)
	local var0_43 = arg1_43:GetSide()

	if arg0_43.moveSideData then
		var0_43 = arg0_43.moveSideData.side
	end

	return var0_43
end

function var0_0.GetPaintingIcon(arg0_44)
	local var0_44

	if arg0_44.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var1_44 = getProxy(PlayerProxy):getRawData().character

		var0_44 = getProxy(BayProxy):getShipById(var1_44):getPrefab()
	else
		var0_44 = (arg0_44.actor ~= var0_0.ACTOR_TYPE_PLAYER or nil) and (arg0_44.actor ~= var0_0.ACTOR_TYPE_TB or nil) and (arg0_44.actor or nil) and (not arg0_44.hideRecordIco or nil) and var1_0[arg0_44.actor].prefab
	end

	if var0_44 == nil and arg0_44:ExistPortrait() then
		var0_44 = arg0_44:GetPortrait()
	end

	return var0_44
end

function var0_0.GetPaintingAndName(arg0_45)
	local var0_45
	local var1_45

	if not UnGamePlayState and arg0_45.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var2_45 = getProxy(PlayerProxy):getRawData().character
		local var3_45 = getProxy(BayProxy):getShipById(var2_45)

		var0_45 = var3_45:getName()
		var1_45 = var3_45:getPainting()
	elseif not UnGamePlayState and arg0_45.actor == var0_0.ACTOR_TYPE_PLAYER then
		if getProxy(PlayerProxy) then
			var0_45 = getProxy(PlayerProxy):getRawData().name
		else
			var0_45 = ""
		end
	elseif not UnGamePlayState and arg0_45.actor == var0_0.ACTOR_TYPE_TB then
		if pg.NewStoryMgr.GetInstance():IsReView() then
			assert(arg0_45.defaultTb and arg0_45.defaultTb > 0, "<<< defaultTb is nil >>>")

			local var4_45 = pg.secretary_special_ship[arg0_45.defaultTb]

			var0_45 = var4_45.name or ""
			var1_45 = var4_45.prefab
		elseif arg0_45.specialTbId then
			local var5_45 = pg.secretary_special_ship[arg0_45.specialTbId]

			assert(var5_45)

			var0_45 = var5_45.name or ""
			var1_45 = var5_45.prefab
		elseif EducateProxy and getProxy(EducateProxy) then
			var1_45, var0_45 = getProxy(EducateProxy):GetStoryInfo()
		else
			var0_45 = ""
		end
	elseif not arg0_45.actor or var1_0[arg0_45.actor] == nil then
		var0_45, var1_45 = nil
	else
		local var6_45 = var1_0[arg0_45.actor]
		local var7_45 = var6_45.ship_group
		local var8_45 = ShipGroup.getDefaultShipConfig(var7_45)

		if not var8_45 then
			var0_45 = var6_45.name
		else
			var0_45 = Ship.getShipName(var8_45.id)
		end

		var1_45 = var6_45.painting
	end

	return HXSet.hxLan(var0_45), var1_45
end

function var0_0.GetShipSkinId(arg0_46)
	if arg0_46.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var0_46 = getProxy(PlayerProxy):getRawData().character

		return getProxy(BayProxy):getShipById(var0_46).skinId
	elseif arg0_46.actor == var0_0.ACTOR_TYPE_PLAYER then
		return nil
	elseif not arg0_46.actor then
		return nil
	else
		return arg0_46.actor
	end
end

function var0_0.IsShowNPainting(arg0_47)
	return arg0_47.showNPainting
end

function var0_0.IsShowWJZPainting(arg0_48)
	return arg0_48.showWJZPainting
end

function var0_0.ShouldGrayPainting(arg0_49)
	return arg0_49.paingtingGray
end

function var0_0.ShouldAddGlitchArtEffect(arg0_50)
	return arg0_50.glitchArt
end

function var0_0.HideOtherPainting(arg0_51)
	return arg0_51.hideOtherPainting
end

function var0_0.GetSubPaintings(arg0_52)
	return _.map(arg0_52.subPaintings or {}, function(arg0_53)
		local var0_53 = pg.ship_skin_template[arg0_53.actor]

		assert(var0_53)

		return {
			actor = arg0_53.actor,
			name = var0_53.painting,
			expression = arg0_53.expression,
			pos = arg0_53.pos,
			dir = arg0_53.dir or 1,
			paintingNoise = arg0_53.paintingNoise or false,
			showNPainting = arg0_53.hidePaintObj or false
		}
	end)
end

function var0_0.NeedDispppearSubPainting(arg0_54)
	return #arg0_54.disappearSeq > 0
end

function var0_0.GetDisappearSeq(arg0_55)
	return arg0_55.disappearSeq
end

function var0_0.GetDisappearTime(arg0_56)
	return arg0_56.disappearTime[1], arg0_56.disappearTime[2]
end

function var0_0.IsNoHeadPainting(arg0_57)
	return arg0_57.nohead
end

function var0_0.GetFontSize(arg0_58)
	return arg0_58.fontSize
end

function var0_0.IsSpinePainting(arg0_59)
	local var0_59 = arg0_59:GetPainting()

	return tobool(var0_59 ~= nil and arg0_59.spine)
end

function var0_0.IsHideSpineBg(arg0_60)
	return arg0_60.spine == 1
end

function var0_0.GetSpineOrderIndex(arg0_61)
	if arg0_61:IsSpinePainting() then
		return arg0_61.spineOrderIndex
	else
		return nil
	end
end

function var0_0.IsLive2dPainting(arg0_62)
	local var0_62 = arg0_62:GetPainting()

	return tobool(var0_62 ~= nil and arg0_62.live2d)
end

function var0_0.GetLive2dPos(arg0_63)
	if arg0_63.live2dOffset then
		return Vector3(arg0_63.live2dOffset[1], arg0_63.live2dOffset[2], arg0_63.live2dOffset[3])
	end
end

function var0_0.GetVirtualShip(arg0_64)
	local var0_64 = arg0_64:GetShipSkinId()
	local var1_64 = pg.ship_skin_template[var0_64].ship_group

	return StoryShip.New({
		skin_id = var0_64
	})
end

function var0_0.GetLive2dAction(arg0_65)
	if type(arg0_65.live2d) == "string" then
		local var0_65 = pg.character_voice[arg0_65.live2d]

		if var0_65 then
			return var0_65.l2d_action
		end

		return arg0_65.live2d
	else
		return nil
	end
end

function var0_0.GetL2dIdleIndex(arg0_66)
	return arg0_66.live2dIdleIndex
end

function var0_0.GetSubActorName(arg0_67)
	if arg0_67.subActorName and arg0_67.subActorName ~= "" then
		local var0_67 = HXSet.hxLan(arg0_67.subActorName)

		return " " .. setColorStr(var0_67, arg0_67.subActorNameColor)
	else
		return ""
	end
end

function var0_0.IsSamePainting(arg0_68, arg1_68)
	local function var0_68()
		return arg1_68:ShouldAddGlitchArtEffect() or arg0_68:ShouldAddGlitchArtEffect()
	end

	return (function()
		return arg0_68:GetPainting() == arg1_68:GetPainting() and arg0_68:IsShowNPainting() == arg1_68:IsShowNPainting() and arg0_68:IsShowWJZPainting() == arg1_68:IsShowWJZPainting()
	end)() and arg0_68:IsLive2dPainting() == arg1_68:IsLive2dPainting() and arg0_68:IsSpinePainting() == arg1_68:IsSpinePainting() and not var0_68()
end

function var0_0.ExistCanMarkNode(arg0_71)
	return arg0_71.canMarkNode ~= nil and type(arg0_71.canMarkNode) == "table" and arg0_71.canMarkNode[1] and arg0_71.canMarkNode[1] ~= "" and arg0_71.canMarkNode[2] and type(arg0_71.canMarkNode[2]) == "table"
end

function var0_0.GetCanMarkNodeData(arg0_72)
	local var0_72 = {}

	for iter0_72, iter1_72 in ipairs(arg0_72.canMarkNode[2] or {}) do
		table.insert(var0_72, iter1_72 .. "")
	end

	return {
		name = arg0_72.canMarkNode[1],
		marks = var0_72
	}
end

function var0_0.OnClear(arg0_73)
	return
end

function var0_0.GetUsingPaintingNames(arg0_74)
	local var0_74 = {}
	local var1_74 = arg0_74:GetPainting()

	if var1_74 ~= nil then
		table.insert(var0_74, var1_74)
	end

	local var2_74 = arg0_74:GetSubPaintings()

	for iter0_74, iter1_74 in ipairs(var2_74) do
		local var3_74 = iter1_74.name

		table.insert(var0_74, var3_74)
	end

	return var0_74
end

return var0_0
