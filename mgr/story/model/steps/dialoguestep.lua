local var0 = class("DialogueStep", import(".StoryStep"))

var0.SIDE_LEFT = 0
var0.SIDE_RIGHT = 1
var0.SIDE_MIDDLE = 2
var0.ACTOR_TYPE_PLAYER = 0
var0.ACTOR_TYPE_FLAGSHIP = -1
var0.ACTOR_TYPE_TB = -2
var0.PAINTING_ACTION_MOVE = "move"
var0.PAINTING_ACTION_SHAKE = "shake"
var0.PAINTING_ACTION_ZOOM = "zoom"
var0.PAINTING_ACTION_ROTATE = "rotate"

local var1 = pg.ship_skin_template

local function var2(arg0)
	local var0 = string.lower(arg0)

	if var0 == "#a9f548" or var0 == "#a9f548ff" then
		return "#5CE6FF"
	elseif var0 == "#ff5c5c" then
		return "#FF9B93"
	elseif var0 == "#ffa500" then
		return "#FFC960"
	elseif var0 == "#ffff4d" then
		return "#FEF15E"
	elseif var0 == "#696969" then
		return "#BDBDBD"
	elseif var0 == "#a020f0" then
		return "#C3ABFF"
	elseif var0 == "#ffffff" then
		return "#FFFFFF"
	else
		return arg0
	end
end

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.actor = arg1.actor

	if arg1.nameColor then
		arg0.nameColor = var2(arg1.nameColor)
	else
		arg0.nameColor = COLOR_WHITE
	end

	arg0.specialTbId = nil

	if arg1.tbActor then
		arg0.specialTbId = arg0.actor
		arg0.actor = var0.ACTOR_TYPE_TB
	end

	arg0.actorName = arg1.actorName
	arg0.subActorName = arg1.factiontag
	arg0.subActorNameColor = arg1.factiontagColor or "#FFFFFF"
	arg0.withoutActorName = arg1.withoutActorName
	arg0.say = arg1.say
	arg0.dynamicBgType = arg1.dynamicBgType
	arg0.fontSize = arg1.fontsize
	arg0.side = arg1.side
	arg0.dir = arg1.dir

	if arg0.dir == 0 then
		arg0.dir = 1
	end

	arg0.expression = arg1.expression
	arg0.typewriter = arg1.typewriter
	arg0.painting = arg1.painting
	arg0.fadeInPaintingTime = arg1.fadeInPaintingTime or 0.15
	arg0.fadeOutPaintingTime = arg1.fadeOutPaintingTime or 0.15
	arg0.actorPosition = arg1.actorPosition
	arg0.dialogShake = arg1.dialogShake
	arg0.moveSideData = arg1.paintingFadeOut
	arg0.paingtingGray = arg1.paingtingGray
	arg0.glitchArt = arg1.paintingNoise
	arg0.hideOtherPainting = arg1.hideOther
	arg0.subPaintings = arg1.subActors
	arg0.disappearSeq = {}
	arg0.disappearTime = {
		0,
		0
	}

	if arg0.subPaintings and #arg0.subPaintings > 0 and arg1.disappearSeq then
		arg0.disappearSeq = arg1.disappearSeq
		arg0.disappearTime = arg1.disappearTime or {
			0,
			0
		}
	end

	arg0.hideRecordIco = arg1.hideRecordIco
	arg0.paingtingScale = arg1.actorScale
	arg0.hidePainting = arg1.withoutPainting
	arg0.actorShadow = arg1.actorShadow
	arg0.actorAlpha = arg1.actorAlpha
	arg0.showNPainting = arg1.hidePaintObj
	arg0.hasPaintbg = arg1.hasPaintbg
	arg0.showWJZPainting = arg1.hidePaintEquip
	arg0.nohead = arg1.nohead
	arg0.live2d = arg1.live2d
	arg0.live2dIdleIndex = arg1.live2dIdleIndex
	arg0.spine = arg1.spine
	arg0.spineOrderIndex = arg1.spineOrderIndex
	arg0.live2dOffset = arg1.live2dOffset
	arg0.contentBGAlpha = arg1.dialogueBgAlpha or 1
	arg0.canMarkNode = arg1.canMarkNode
	arg0.portrait = arg1.portrait
	arg0.glitchArtForPortrait = arg1.portraitNoise

	if arg0.hidePainting or arg0.actor == nil then
		arg0.actor = nil
		arg0.hideOtherPainting = true
	end

	arg0.paintRwIndex = arg1.paintRwIndex or 0
	arg0.action = arg1.action or {}
end

function var0.GetBgName(arg0)
	if arg0.dynamicBgType and arg0.dynamicBgType == var0.ACTOR_TYPE_TB and getProxy(EducateProxy) and not pg.NewStoryMgr.GetInstance():IsReView() then
		local var0, var1, var2 = getProxy(EducateProxy):GetStoryInfo()

		return (arg0:Convert2StoryBg(var2))
	else
		return var0.super.GetBgName(arg0)
	end
end

function var0.Convert2StoryBg(arg0, arg1)
	return ({
		educate_tb_1 = "bg_project_tb_room1",
		educate_tb_2 = "bg_project_tb_room2",
		educate_tb_3 = "bg_project_tb_room3"
	})[arg1] or arg1
end

function var0.GetPaintingRwIndex(arg0)
	if not arg0.glitchArt then
		return 0
	end

	if not arg0.expression then
		return 0
	end

	return arg0.paintRwIndex
end

function var0.ExistPortrait(arg0)
	return arg0.portrait ~= nil
end

function var0.GetPortrait(arg0)
	if type(arg0.portrait) == "number" then
		return pg.ship_skin_template[arg0.portrait].painting
	elseif type(arg0.portrait) == "string" then
		return arg0.portrait
	else
		return nil
	end
end

function var0.ShouldGlitchArtForPortrait(arg0)
	return arg0.glitchArtForPortrait
end

function var0.GetMode(arg0)
	return Story.MODE_DIALOGUE
end

function var0.GetContentBGAlpha(arg0)
	return arg0.contentBGAlpha
end

function var0.GetSpineExPression(arg0)
	if arg0.expression then
		return arg0.expression
	end
end

function var0.GetExPression(arg0)
	if arg0.expression then
		return arg0.expression
	else
		local var0 = arg0:GetPainting()

		if var0 and ShipExpressionHelper.DefaultFaceless(var0) then
			return ShipExpressionHelper.GetDefaultFace(var0)
		end
	end
end

function var0.ShouldAddHeadMaskWhenFade(arg0)
	if arg0:ShouldAddGlitchArtEffect() then
		return false
	end

	if arg0:IsNoHeadPainting() then
		return false
	end

	if not arg0:GetExPression() then
		return false
	end

	return true
end

function var0.ShouldGrayingPainting(arg0, arg1)
	return arg1:GetPainting() ~= nil and not arg0:IsSameSide(arg1)
end

function var0.ShouldGrayingOutPainting(arg0, arg1)
	return arg0:GetPainting() ~= nil and not arg0:IsSameSide(arg1)
end

function var0.ShouldFadeInPainting(arg0)
	if not arg0:GetPainting() then
		return false
	end

	if arg0:IsLive2dPainting() or arg0:IsSpinePainting() then
		return false
	end

	local var0 = arg0:GetFadeInPaintingTime()

	if not var0 or var0 <= 0 then
		return false
	end

	return true
end

function var0.GetTypewriter(arg0)
	return arg0.typewriter
end

function var0.ShouldFaceBlack(arg0)
	return arg0.actorShadow
end

function var0.GetPaintingData(arg0)
	local var0 = arg0.painting or {}

	return {
		alpha = var0.alpha or 0.3,
		time = var0.time or 1
	}
end

function var0.GetFadeInPaintingTime(arg0)
	return arg0.fadeInPaintingTime
end

function var0.GetFadeOutPaintingTime(arg0)
	return arg0.fadeOutPaintingTime
end

function var0.GetPaintingDir(arg0)
	local var0 = arg0.paingtingScale or 1

	return (arg0.dir or 1) * var0
end

function var0.GetTag(arg0)
	if arg0.glitchArt == true then
		return 2
	else
		return 1
	end
end

function var0.GetPaintingAlpha(arg0)
	return arg0.actorAlpha
end

function var0.GetPaitingOffst(arg0)
	return arg0.actorPosition
end

function var0.GetSound(arg0)
	return arg0.sound
end

function var0.GetPaintingActions(arg0)
	return arg0.action
end

function var0.GetPaintingMoveToSide(arg0)
	return arg0.moveSideData
end

function var0.ShouldMoveToSide(arg0)
	return arg0.moveSideData ~= nil
end

function var0.GetPaintingAction(arg0, arg1)
	local var0 = {}
	local var1 = arg0:GetPaintingActions()

	for iter0, iter1 in ipairs(var1) do
		if iter1.type == arg1 then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.GetSide(arg0)
	return arg0.side
end

function var0.GetContent(arg0)
	if not arg0.say then
		return "..."
	end

	local var0 = arg0.say

	if arg0:ShouldReplacePlayer() then
		var0 = arg0:ReplacePlayerName(var0)
	end

	if arg0:ShouldReplaceTb() then
		var0 = arg0:ReplaceTbName(var0)
	end

	if PLATFORM_CODE ~= PLATFORM_US then
		var0 = SwitchSpecialChar(HXSet.hxLan(var0), true)
	else
		var0 = HXSet.hxLan(var0)
	end

	return var0
end

function var0.GetNameWithColor(arg0)
	local var0 = arg0:GetName()

	if not var0 then
		return nil
	end

	local var1 = arg0:GetNameColor()

	return setColorStr(var0, var1)
end

function var0.GetNameColor(arg0)
	return arg0.nameColor or COLOR_WHITE
end

function var0.GetNameColorCode(arg0)
	local var0 = arg0:GetNameColor()

	return string.gsub(var0, "#", "")
end

function var0.GetCustomActorName(arg0)
	if type(arg0.actorName) == "number" and arg0.actorName == 0 and getProxy(PlayerProxy) then
		return getProxy(PlayerProxy):getRawData().name
	elseif type(arg0.actorName) == "string" then
		return arg0.actorName
	else
		return ""
	end
end

function var0.GetName(arg0)
	local var0 = arg0.actorName and arg0:GetCustomActorName() or arg0:GetPaintingAndName() or ""

	if not var0 or var0 == "" or arg0.withoutActorName then
		return nil
	end

	if arg0:ShouldReplacePlayer() then
		var0 = arg0:ReplacePlayerName(var0)
	end

	if arg0:ShouldReplaceTb() then
		var0 = arg0:ReplaceTbName(var0)
	end

	return (HXSet.hxLan(var0))
end

function var0.GetPainting(arg0)
	local var0, var1 = arg0:GetPaintingAndName()

	return var1
end

function var0.ExistPainting(arg0)
	return arg0:GetPainting() ~= nil
end

function var0.ShouldShakeDailogue(arg0)
	return arg0.dialogShake ~= nil
end

function var0.GetShakeDailogueData(arg0)
	return arg0.dialogShake
end

function var0.IsSameSide(arg0, arg1)
	local var0 = arg0:GetPrevSide(arg1)
	local var1 = arg0:GetSide()

	return var0 ~= nil and var1 ~= nil and var0 == var1
end

function var0.GetPrevSide(arg0, arg1)
	local var0 = arg1:GetSide()

	if arg0.moveSideData then
		var0 = arg0.moveSideData.side
	end

	return var0
end

function var0.GetPaintingIcon(arg0)
	local var0

	if arg0.actor == var0.ACTOR_TYPE_FLAGSHIP then
		local var1 = getProxy(PlayerProxy):getRawData().character

		var0 = getProxy(BayProxy):getShipById(var1):getPrefab()
	else
		var0 = (arg0.actor ~= var0.ACTOR_TYPE_PLAYER or nil) and (arg0.actor ~= var0.ACTOR_TYPE_TB or nil) and (arg0.actor or nil) and (not arg0.hideRecordIco or nil) and var1[arg0.actor].prefab
	end

	if var0 == nil and arg0:ExistPortrait() then
		var0 = arg0:GetPortrait()
	end

	return var0
end

function var0.GetPaintingAndName(arg0)
	local var0
	local var1

	if not UnGamePlayState and arg0.actor == var0.ACTOR_TYPE_FLAGSHIP then
		local var2 = getProxy(PlayerProxy):getRawData().character
		local var3 = getProxy(BayProxy):getShipById(var2)

		var0 = var3:getName()
		var1 = var3:getPainting()
	elseif not UnGamePlayState and arg0.actor == var0.ACTOR_TYPE_PLAYER then
		if getProxy(PlayerProxy) then
			var0 = getProxy(PlayerProxy):getRawData().name
		else
			var0 = ""
		end
	elseif not UnGamePlayState and arg0.actor == var0.ACTOR_TYPE_TB then
		if pg.NewStoryMgr.GetInstance():IsReView() then
			assert(arg0.defaultTb and arg0.defaultTb > 0, "<<< defaultTb is nil >>>")

			local var4 = pg.secretary_special_ship[arg0.defaultTb]

			var0 = var4.name or ""
			var1 = var4.prefab
		elseif arg0.specialTbId then
			local var5 = pg.secretary_special_ship[arg0.specialTbId]

			assert(var5)

			var0 = var5.name or ""
			var1 = var5.prefab
		elseif EducateProxy and getProxy(EducateProxy) then
			var1, var0 = getProxy(EducateProxy):GetStoryInfo()
		else
			var0 = ""
		end
	elseif not arg0.actor or var1[arg0.actor] == nil then
		var0, var1 = nil
	else
		local var6 = var1[arg0.actor]
		local var7 = var6.ship_group
		local var8 = ShipGroup.getDefaultShipConfig(var7)

		if not var8 then
			var0 = var6.name
		else
			var0 = Ship.getShipName(var8.id)
		end

		var1 = var6.painting
	end

	return HXSet.hxLan(var0), var1
end

function var0.GetShipSkinId(arg0)
	if arg0.actor == var0.ACTOR_TYPE_FLAGSHIP then
		local var0 = getProxy(PlayerProxy):getRawData().character

		return getProxy(BayProxy):getShipById(var0).skinId
	elseif arg0.actor == var0.ACTOR_TYPE_PLAYER then
		return nil
	elseif not arg0.actor then
		return nil
	else
		return arg0.actor
	end
end

function var0.IsShowNPainting(arg0)
	return arg0.showNPainting
end

function var0.IsShowWJZPainting(arg0)
	return arg0.showWJZPainting
end

function var0.ShouldGrayPainting(arg0)
	return arg0.paingtingGray
end

function var0.ShouldAddGlitchArtEffect(arg0)
	return arg0.glitchArt
end

function var0.HideOtherPainting(arg0)
	return arg0.hideOtherPainting
end

function var0.GetSubPaintings(arg0)
	return _.map(arg0.subPaintings or {}, function(arg0)
		local var0 = pg.ship_skin_template[arg0.actor]

		assert(var0)

		return {
			actor = arg0.actor,
			name = var0.painting,
			expression = arg0.expression,
			pos = arg0.pos,
			dir = arg0.dir or 1,
			paintingNoise = arg0.paintingNoise or false,
			showNPainting = arg0.hidePaintObj or false
		}
	end)
end

function var0.NeedDispppearSubPainting(arg0)
	return #arg0.disappearSeq > 0
end

function var0.GetDisappearSeq(arg0)
	return arg0.disappearSeq
end

function var0.GetDisappearTime(arg0)
	return arg0.disappearTime[1], arg0.disappearTime[2]
end

function var0.IsNoHeadPainting(arg0)
	return arg0.nohead
end

function var0.GetFontSize(arg0)
	return arg0.fontSize
end

function var0.IsSpinePainting(arg0)
	local var0 = arg0:GetPainting()

	return tobool(var0 ~= nil and arg0.spine)
end

function var0.IsHideSpineBg(arg0)
	return arg0.spine == 1
end

function var0.GetSpineOrderIndex(arg0)
	if arg0:IsSpinePainting() then
		return arg0.spineOrderIndex
	else
		return nil
	end
end

function var0.IsLive2dPainting(arg0)
	local var0 = arg0:GetPainting()

	return tobool(var0 ~= nil and arg0.live2d)
end

function var0.GetLive2dPos(arg0)
	if arg0.live2dOffset then
		return Vector3(arg0.live2dOffset[1], arg0.live2dOffset[2], arg0.live2dOffset[3])
	end
end

function var0.GetVirtualShip(arg0)
	local var0 = arg0:GetShipSkinId()
	local var1 = pg.ship_skin_template[var0].ship_group

	return StoryShip.New({
		skin_id = var0
	})
end

function var0.GetLive2dAction(arg0)
	if type(arg0.live2d) == "string" then
		local var0 = pg.character_voice[arg0.live2d]

		if var0 then
			return var0.l2d_action
		end

		return arg0.live2d
	else
		return nil
	end
end

function var0.GetL2dIdleIndex(arg0)
	return arg0.live2dIdleIndex
end

function var0.GetSubActorName(arg0)
	if arg0.subActorName and arg0.subActorName ~= "" then
		local var0 = HXSet.hxLan(arg0.subActorName)

		return " " .. setColorStr(var0, arg0.subActorNameColor)
	else
		return ""
	end
end

function var0.IsSamePainting(arg0, arg1)
	local function var0()
		return arg1:ShouldAddGlitchArtEffect() or arg0:ShouldAddGlitchArtEffect()
	end

	return (function()
		return arg0:GetPainting() == arg1:GetPainting() and arg0:IsShowNPainting() == arg1:IsShowNPainting() and arg0:IsShowWJZPainting() == arg1:IsShowWJZPainting()
	end)() and arg0:IsLive2dPainting() == arg1:IsLive2dPainting() and arg0:IsSpinePainting() == arg1:IsSpinePainting() and not var0()
end

function var0.ExistCanMarkNode(arg0)
	return arg0.canMarkNode ~= nil and type(arg0.canMarkNode) == "table" and arg0.canMarkNode[1] and arg0.canMarkNode[1] ~= "" and arg0.canMarkNode[2] and type(arg0.canMarkNode[2]) == "table"
end

function var0.GetCanMarkNodeData(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.canMarkNode[2] or {}) do
		table.insert(var0, iter1 .. "")
	end

	return {
		name = arg0.canMarkNode[1],
		marks = var0
	}
end

function var0.OnClear(arg0)
	return
end

function var0.GetUsingPaintingNames(arg0)
	local var0 = {}
	local var1 = arg0:GetPainting()

	if var1 ~= nil then
		table.insert(var0, var1)
	end

	local var2 = arg0:GetSubPaintings()

	for iter0, iter1 in ipairs(var2) do
		local var3 = iter1.name

		table.insert(var0, var3)
	end

	return var0
end

return var0
