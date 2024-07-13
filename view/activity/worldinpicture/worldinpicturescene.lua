local var0_0 = class("WorldInPictureScene", import("...base.BaseUI"))
local var1_0 = 0
local var2_0 = 1

function var0_0.getUIName(arg0_1)
	return "WorldInPictureUI"
end

function var0_0.emit(arg0_2, ...)
	if arg0_2.inAniming then
		return
	end

	var0_0.super.emit(arg0_2, ...)
end

function var0_0.OnOpenCellErro(arg0_3, arg1_3)
	if arg1_3 then
		arg0_3.onkeyTravelProcess = false

		arg0_3:UpdateTravelBtnState()
	end
end

function var0_0.OnOpenCell(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4:CloseSelector(arg1_4, arg2_4)
	arg0_4:HideBox(arg1_4, arg2_4)

	arg0_4.inAniming = true

	local var0_4 = arg0_4.cells[arg1_4][arg2_4]
	local var1_4 = var0_4.gameObject.transform.anchoredPosition

	arg0_4:DoAnimtion("picture_faguang", var1_4, function()
		var0_4.alpha = 1

		if arg3_4 and arg0_4.data:ExistBox(arg1_4, arg2_4) then
			arg0_4:RpAnim(arg1_4, arg2_4)
		end

		arg0_4:HightLightOpenArea(arg1_4, arg2_4)
		arg0_4:UpdatePoints()
		arg0_4:UpdateSwitcherState()

		local var0_5 = arg0_4.data:IsFirstTravel()

		arg0_4:UpdateChar(Vector2(arg1_4, arg2_4), not var0_5)
		arg0_4:SaveCharPosition(arg1_4, arg2_4)

		arg0_4.inAniming = false
		arg0_4.forceStopTravelPorcess = false

		if arg3_4 then
			local var1_5 = arg0_4.onkeyTravelProcess

			arg0_4.onkeyTravelProcess = false

			arg0_4:UpdateTravelBtnState()

			if not var1_5 or not arg0_4.data:FindNextTravelable() then
				arg0_4:emit(WorldInPictureMediator.RESULT_ONEKEY_AWARD)
			elseif var1_5 == true then
				triggerButton(arg0_4.onekeyTravelBtn)
			end
		end
	end)
end

function var0_0.CloseSelector(arg0_6, arg1_6, arg2_6)
	if arg0_6.data:IsFirstTravel() then
		for iter0_6, iter1_6 in ipairs(arg0_6.selectors) do
			for iter2_6, iter3_6 in ipairs(iter1_6) do
				iter3_6.alpha = 0
			end
		end
	else
		local var0_6 = arg0_6.selectors[arg1_6][arg2_6]

		if var0_6 and var0_6.alpha ~= 0 then
			var0_6.alpha = 0
		end
	end
end

function var0_0.HightLightOpenArea(arg0_7, arg1_7, arg2_7)
	local var0_7 = {
		Vector2(arg1_7 + 1, arg2_7),
		Vector2(arg1_7, arg2_7 + 1),
		Vector2(arg1_7 - 1, arg2_7),
		Vector2(arg1_7, arg2_7 - 1)
	}

	local function var1_7(arg0_8)
		if arg0_7.data:IsOpened(arg0_8.x, arg0_8.y) or arg0_7.data:OutSide(arg0_8.x, arg0_8.y) then
			return
		end

		if not arg0_7.selectors[arg0_8.x] or not arg0_7.selectors[arg0_8.x][arg0_8.y] then
			arg0_7:CreateSelector(arg0_8.x, arg0_8.y)
		else
			arg0_7.selectors[arg0_8.x][arg0_8.y].alpha = 1
		end
	end

	_.each(var0_7, var1_7)
end

function var0_0.RpAnim(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9:GetRedPacket()

	var0_9.anchoredPosition = arg0_9.cells[arg1_9][arg2_9].gameObject.transform.anchoredPosition + Vector2(48, 48)

	LeanTween.value(var0_9.gameObject, var0_9.anchoredPosition.y, var0_9.anchoredPosition.y + 35, 0.75):setOnUpdate(System.Action_float(function(arg0_10)
		var0_9.anchoredPosition = Vector2(var0_9.anchoredPosition.x, arg0_10)
	end)):setOnComplete(System.Action(function()
		if arg0_9.exited then
			return
		end

		setActive(var0_9, false)
		table.insert(arg0_9.redpackets, var0_9)
	end))
end

function var0_0.HideBox(arg0_12, arg1_12, arg2_12)
	local var0_12

	if arg0_12.boxes[arg1_12] then
		var0_12 = arg0_12.boxes[arg1_12][arg2_12]
	end

	if var0_12 then
		var0_12.alpha = 0
	end
end

function var0_0.OnDrawAreaErro(arg0_13, arg1_13)
	if arg1_13 then
		arg0_13.onkeyDrawPorcess = false

		arg0_13:UpdateDrawBtnState()
	end
end

function var0_0.OnDrawArea(arg0_14, arg1_14, arg2_14, arg3_14)
	arg0_14:HideDrawarea(arg1_14, arg2_14)

	arg0_14.inAniming = true

	arg0_14:CreateAnimal(arg1_14, arg2_14, false, function(arg0_15)
		local var0_15 = arg0_14.data:GetDrawAnimData(arg1_14, arg2_14)
		local var1_15 = arg0_15.sizeDelta.x * arg0_15.localScale.x * 0.5 + 90
		local var2_15 = arg0_15.sizeDelta.y * arg0_15.localScale.y * 0.5
		local var3_15 = Vector2(var0_15[2] + var1_15, var0_15[3] - var2_15)

		arg0_14:DoAnimtion("picture_bichu", var3_15, function()
			LeanTween.value(arg0_15.gameObject, 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_17)
				if arg0_14.exited then
					return
				end

				arg0_15:GetComponent(typeof(CanvasGroup)).alpha = arg0_17
			end))
			arg0_14:UpdatePoints()

			arg0_14.inAniming = false
			arg0_14.forceStopDrawPorcess = false

			if arg3_14 then
				local var0_16 = arg0_14.onkeyDrawPorcess

				arg0_14.onkeyDrawPorcess = false

				arg0_14:UpdateDrawBtnState()

				if not var0_16 or not arg0_14.data:FindNextDrawableAreaHead() then
					arg0_14:emit(WorldInPictureMediator.RESULT_ONEKEY_AWARD)
				elseif arg3_14 and var0_16 == true then
					triggerButton(arg0_14.onekeyDrawBtn)
				end
			end
		end)
	end)
end

function var0_0.HideDrawarea(arg0_18, arg1_18, arg2_18)
	local var0_18

	if arg0_18.drawableAare[arg1_18] then
		var0_18 = arg0_18.drawableAare[arg1_18][arg2_18]
	end

	if var0_18 then
		var0_18.alpha = 0
	end
end

function var0_0.SetData(arg0_19, arg1_19)
	arg0_19.data = arg1_19
end

function var0_0.init(arg0_20)
	Input.multiTouchEnabled = false
	arg0_20.redpacket = arg0_20:findTF("redpackets/redpacket")
	arg0_20.lineHrzTpl = arg0_20:findTF("lines/line_hrz")
	arg0_20.lineVecTpl = arg0_20:findTF("lines/line_vec")
	arg0_20.animalTpl = arg0_20:findTF("animals/animal")
	arg0_20.areaTpl = arg0_20:findTF("drawablearea/area")
	arg0_20.boxTpl = arg0_20:findTF("boxes/box")
	arg0_20.selectorTpl = arg0_20:findTF("selectors/selector")
	arg0_20.tpl = arg0_20:findTF("grids/grid")
	arg0_20.backBtn = arg0_20:findTF("back")
	arg0_20.helpBtn = arg0_20:findTF("help")
	arg0_20.travelPointTxt = arg0_20:findTF("points/travel"):GetComponent(typeof(Text))
	arg0_20.drawPointTxt = arg0_20:findTF("points/draw"):GetComponent(typeof(Text))
	arg0_20.travelProgressTxt = arg0_20:findTF("progress/travel"):GetComponent(typeof(Text))
	arg0_20.drawProgressTxt = arg0_20:findTF("progress/draw"):GetComponent(typeof(Text))
	arg0_20.switchBtn = arg0_20:findTF("swticher")
	arg0_20.onDisable = arg0_20.switchBtn:Find("on_disable")
	arg0_20.btnOn = arg0_20.switchBtn:Find("on_enable/draw")
	arg0_20.btnOff = arg0_20.switchBtn:Find("on_enable/off")
	arg0_20.onekeyTravelBtn = arg0_20:findTF("onekey_travel")
	arg0_20.onekeyTravelingBtn = arg0_20:findTF("onekey_travel/Image")
	arg0_20.onekeyDrawBtn = arg0_20:findTF("onekey_draw")
	arg0_20.onekeyDrawingBtn = arg0_20:findTF("onekey_draw/Image")
	arg0_20.char = arg0_20:findTF("char/char")

	setActive(arg0_20.char, false)

	arg0_20.selectorContainer = arg0_20:findTF("selectors"):GetComponent(typeof(CanvasGroup))
	arg0_20.drawableAreaContainer = arg0_20:findTF("drawablearea"):GetComponent(typeof(CanvasGroup))
	arg0_20.startPos = arg0_20.tpl.anchoredPosition
	arg0_20.offset = Vector2(0.5, 0.5)
	arg0_20.width = arg0_20.tpl.sizeDelta.x
	arg0_20.height = arg0_20.tpl.sizeDelta.y
	arg0_20.cells = {}
	arg0_20.selectors = {}
	arg0_20.boxes = {}
	arg0_20.drawableAare = {}
	arg0_20.animals = {}
	arg0_20.redpackets = {
		arg0_20.redpacket
	}
end

function var0_0.didEnter(arg0_21)
	onButton(arg0_21, arg0_21.backBtn, function()
		if arg0_21.opType == var1_0 and arg0_21.onkeyTravelProcess then
			arg0_21.onkeyTravelProcess = false

			arg0_21:UpdateTravelBtnState()

			return
		elseif arg0_21.opType == var2_0 and arg0_21.onkeyDrawPorcess then
			arg0_21.onkeyDrawPorcess = false

			arg0_21:UpdateDrawBtnState()

			return
		end

		arg0_21:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_21, arg0_21.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.worldinpicture_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.onekeyTravelBtn, function()
		if arg0_21.forceStopTravelPorcess then
			return
		end

		if arg0_21.data:IsTravelAll() then
			return
		end

		if arg0_21.data:GetTravelPoint() <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("worldinpicture_tavel_point_tip"))

			return
		end

		if arg0_21.onkeyTravelProcess then
			arg0_21.onkeyTravelProcess = false
			arg0_21.forceStopTravelPorcess = true

			arg0_21:UpdateTravelBtnState()

			return
		end

		local var0_24, var1_24 = arg0_21.data:FindNextTravelable()

		if var0_24 and var1_24 then
			arg0_21.onkeyTravelProcess = true

			arg0_21:UpdateTravelBtnState()
			arg0_21:emit(WorldInPictureMediator.ON_AUTO_TRAVEL, var0_24.x, var0_24.y, var1_24)
		end
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.onekeyDrawBtn, function()
		if arg0_21.forceStopDrawPorcess then
			return
		end

		if arg0_21.data:IsDrawAll() then
			return
		end

		if arg0_21.data:GetDrawPoint() <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("worldinpicture_draw_point_tip"))

			return
		end

		if arg0_21.onkeyDrawPorcess then
			arg0_21.onkeyDrawPorcess = false
			arg0_21.forceStopDrawPorcess = true

			arg0_21:UpdateDrawBtnState()

			return
		end

		local var0_25, var1_25 = arg0_21.data:FindNextDrawableAreaHead()

		if var0_25 and var1_25 then
			arg0_21.onkeyDrawPorcess = true

			arg0_21:UpdateDrawBtnState()
			arg0_21:emit(WorldInPictureMediator.ON_AUTO_DRAW, var0_25.x, var0_25.y, var1_25)
		end
	end, SFX_PANEL)

	arg0_21.opType = var1_0

	onButton(arg0_21, arg0_21.onDisable, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("worldinpicture_not_area_can_draw"))
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.btnOn, function()
		if arg0_21.opType == var1_0 and arg0_21.onkeyTravelProcess then
			arg0_21.onkeyTravelProcess = false

			arg0_21:UpdateTravelBtnState()

			return
		elseif arg0_21.opType == var2_0 and arg0_21.onkeyDrawPorcess then
			arg0_21.onkeyDrawPorcess = false

			arg0_21:UpdateDrawBtnState()

			return
		end

		if arg0_21.inAniming then
			return
		end

		arg0_21.opType = var2_0

		arg0_21:UpdateSwitcherState()
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.btnOff, function()
		if arg0_21.opType == var1_0 and arg0_21.onkeyTravelProcess then
			arg0_21.onkeyTravelProcess = false

			arg0_21:UpdateTravelBtnState()

			return
		elseif arg0_21.opType == var2_0 and arg0_21.onkeyDrawPorcess then
			arg0_21.onkeyDrawPorcess = false

			arg0_21:UpdateDrawBtnState()

			return
		end

		if arg0_21.inAniming then
			return
		end

		arg0_21.opType = var1_0

		arg0_21:UpdateSwitcherState()
	end, SFX_PANEL)
	arg0_21:UpdateSwitcherState()
	arg0_21:InitView()
end

function var0_0.UpdateDrawBtnState(arg0_29)
	setActive(arg0_29.onekeyDrawingBtn, arg0_29.onkeyDrawPorcess)
end

function var0_0.UpdateTravelBtnState(arg0_30)
	setActive(arg0_30.onekeyTravelingBtn, arg0_30.onkeyTravelProcess)
end

function var0_0.GetRecordCharPos(arg0_31)
	local var0_31 = getProxy(PlayerProxy):getRawData().id
	local var1_31 = PlayerPrefs.GetString("WorldInPictureScene_1" .. var0_31, "0#0")
	local var2_31 = string.split(var1_31, "#")

	return Vector2(tonumber(var2_31[1]), tonumber(var2_31[2]))
end

function var0_0.SaveCharPosition(arg0_32, arg1_32, arg2_32)
	local var0_32 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString("WorldInPictureScene_1" .. var0_32, arg1_32 .. "#" .. arg2_32)
	PlayerPrefs.Save()
end

function var0_0.moveChar(arg0_33, arg1_33, arg2_33, arg3_33)
	if LeanTween.isTweening(go(arg0_33.char)) then
		LeanTween.cancel(go(arg0_33.char))
	end

	if isActive(arg0_33.char) then
		arg0_33:hideChar(function()
			arg0_33:showChar(arg1_33, arg2_33, arg3_33)
		end)
	else
		arg0_33:showChar(arg1_33, arg2_33, arg3_33)
	end
end

function var0_0.showChar(arg0_35, arg1_35, arg2_35, arg3_35)
	arg0_35.char.transform.localPosition = Vector3(arg1_35, arg2_35 + 50)

	setActive(arg0_35.char, true)
	LeanTween.value(go(arg0_35.char), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_36)
		GetOrAddComponent(arg0_35.char, typeof(CanvasGroup)).alpha = arg0_36
	end))
	LeanTween.moveLocal(go(arg0_35.char), Vector3(arg1_35, arg2_35, 0), 0.2):setOnComplete(System.Action(function()
		if arg3_35 then
			arg3_35()
		end
	end))
end

function var0_0.hideChar(arg0_38, arg1_38)
	LeanTween.value(go(arg0_38.char), 1, 0, 0.2):setOnUpdate(System.Action_float(function(arg0_39)
		GetOrAddComponent(arg0_38.char, typeof(CanvasGroup)).alpha = arg0_39
	end))

	local var0_38 = arg0_38.char.transform.localPosition

	LeanTween.moveLocal(go(arg0_38.char), Vector3(var0_38.x, var0_38.y + 50, 0), 0.2):setOnComplete(System.Action(function()
		setActive(arg0_38.char, false)

		if arg1_38 then
			arg1_38()
		end
	end))
end

function var0_0.UpdateChar(arg0_41, arg1_41, arg2_41)
	if arg1_41 == Vector2.zero then
		setActive(arg0_41.char, false)

		return
	end

	if LeanTween.isTweening(arg0_41.char) then
		LeanTween.cancel(arg0_41.char)
	end

	if arg0_41.data:IsTravelAll() then
		setActive(arg0_41.char, false)

		return
	end

	local var0_41 = arg0_41.cells[arg1_41.x][arg1_41.y].gameObject.transform.anchoredPosition
	local var1_41 = Vector2(var0_41.x, var0_41.y - 50)

	if arg2_41 then
		arg0_41:moveChar(var1_41.x, var1_41.y, function()
			return
		end)
	else
		arg0_41.char.transform.localPosition = var1_41
	end
end

function var0_0.UpdateSwitcherState(arg0_43)
	local var0_43 = arg0_43.opType == var2_0
	local var1_43 = arg0_43.data:AnyAreaCanDraw()

	setActive(arg0_43.btnOff, var0_43)
	setActive(arg0_43.onDisable, not var0_43 and not var1_43)
	setActive(arg0_43.btnOn, not var0_43 and var1_43)
	setActive(arg0_43.onekeyTravelBtn, not var0_43)
	setActive(arg0_43.onekeyDrawBtn, var0_43)
	setActive(arg0_43.char, not var0_43 and not arg0_43.data:IsTravelAll())

	arg0_43.selectorContainer.alpha = var0_43 and 0 or 1
	arg0_43.drawableAreaContainer.alpha = var0_43 and 1 or 0

	if var0_43 then
		arg0_43:UpdateDrawableAreas()
	end
end

function var0_0.InitView(arg0_44)
	local var0_44, var1_44 = arg0_44.data:GetMapRowAndColumn()
	local var2_44 = {}

	for iter0_44 = 1, var0_44 do
		table.insert(var2_44, function(arg0_45)
			for iter0_45 = var1_44, 1, -1 do
				arg0_44:CreateCell(iter0_44, iter0_45, (iter0_44 - 1) * var1_44 + iter0_45)
			end

			onNextTick(arg0_45)
		end)
	end

	seriesAsync(var2_44, function()
		arg0_44:InitLines()
		arg0_44:UpdateChar(arg0_44:GetRecordCharPos())
	end)
	arg0_44:UpdatePoints()
end

function var0_0.InitLines(arg0_47)
	local var0_47, var1_47 = arg0_47.data:GetMapRowAndColumn()
	local var2_47 = arg0_47.tpl.sizeDelta.y * var0_47 + 10

	for iter0_47 = 1, var1_47 - 1 do
		local var3_47 = iter0_47 == 1 and arg0_47.lineVecTpl or Object.Instantiate(arg0_47.lineVecTpl, arg0_47.lineVecTpl.parent)

		var3_47.sizeDelta = Vector2(var3_47.sizeDelta.x, var2_47)

		local var4_47 = arg0_47.cells[1][iter0_47]
		local var5_47 = var4_47.gameObject.transform.anchoredPosition.x + var4_47.gameObject.transform.sizeDelta.x * 0.5

		var3_47.anchoredPosition = Vector2(var5_47 + arg0_47.offset.x, var3_47.anchoredPosition.y)
	end

	local var6_47 = arg0_47.tpl.sizeDelta.x * var1_47 + 20

	for iter1_47 = 1, var0_47 - 1 do
		local var7_47 = iter1_47 == 1 and arg0_47.lineHrzTpl or Object.Instantiate(arg0_47.lineHrzTpl, arg0_47.lineHrzTpl.parent)

		var7_47.sizeDelta = Vector2(var7_47.sizeDelta.x, var6_47)

		local var8_47 = arg0_47.cells[iter1_47][1]
		local var9_47 = var8_47.gameObject.transform.anchoredPosition.y - var8_47.gameObject.transform.sizeDelta.y * 0.5

		var7_47.anchoredPosition = Vector2(var7_47.anchoredPosition.x, var9_47 + arg0_47.offset.y)
	end
end

function var0_0.CreateCell(arg0_48, arg1_48, arg2_48, arg3_48)
	if arg0_48.exited then
		return
	end

	local var0_48 = arg2_48 == 1 and arg1_48 == 1 and arg0_48.tpl or Object.Instantiate(arg0_48.tpl, arg0_48.tpl.parent).transform
	local var1_48 = arg0_48.startPos.x + (arg2_48 - 1) * (arg0_48.width + arg0_48.offset.x)
	local var2_48 = arg0_48.startPos.y - (arg1_48 - 1) * (arg0_48.height + arg0_48.offset.y)

	LoadSpriteAtlasAsync("ui/WorldInPicture_atlas", "view_" .. arg3_48 - 1, function(arg0_49)
		if arg0_48.exited then
			return
		end

		local var0_49 = var0_48:GetComponent(typeof(Image))

		var0_49.sprite = arg0_49

		var0_49:SetNativeSize()

		var0_48.anchoredPosition = Vector2(var1_48, var2_48)

		arg0_48:CreateSelector(arg1_48, arg2_48)
		arg0_48:CreateBox(arg1_48, arg2_48)
		arg0_48:CreateDrawableArea(arg1_48, arg2_48)
		arg0_48:CreateAnimal(arg1_48, arg2_48, true)
	end)

	if not arg0_48.cells[arg1_48] then
		arg0_48.cells[arg1_48] = {}
	end

	onButton(arg0_48, var0_48, function()
		if arg0_48.opType == var1_0 then
			if arg0_48.onkeyTravelProcess then
				arg0_48.onkeyTravelProcess = false

				arg0_48:UpdateTravelBtnState()

				return
			end

			if arg0_48.data:IsTravelAll() then
				return
			end

			if arg0_48.data:GetTravelPoint() <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("worldinpicture_tavel_point_tip"))

				return
			end

			if arg0_48.data:CanSelect(arg1_48, arg2_48) then
				arg0_48:emit(WorldInPictureMediator.ON_TRAVEL, arg1_48, arg2_48, arg3_48)
			end
		elseif arg0_48.opType == var2_0 then
			if arg0_48.onkeyDrawPorcess then
				arg0_48.onkeyDrawPorcess = false

				arg0_48:UpdateDrawBtnState()

				return
			end

			if arg0_48.data:IsDrawAll() then
				return
			end

			if arg0_48.data:GetDrawPoint() <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("worldinpicture_draw_point_tip"))

				return
			end

			if arg0_48.data:CanDraw(arg1_48, arg2_48) then
				local var0_50, var1_50, var2_50 = arg0_48.data:Convert2DrawAreaHead(arg1_48, arg2_48)

				arg0_48:emit(WorldInPictureMediator.ON_DRAW, var0_50, var1_50, var2_50)
			end
		end
	end, SFX_PANEL)

	local var3_48 = var0_48:GetComponent(typeof(CanvasGroup))

	var3_48.alpha = arg0_48.data:IsOpened(arg1_48, arg2_48) and 1 or 0
	arg0_48.cells[arg1_48][arg2_48] = var3_48
end

function var0_0.CreateSelector(arg0_51, arg1_51, arg2_51)
	if not arg0_51.data:CanSelect(arg1_51, arg2_51) then
		return
	end

	local var0_51 = table.getCount(arg0_51.selectors) == 0 and arg0_51.selectorTpl or Object.Instantiate(arg0_51.selectorTpl, arg0_51.selectorTpl.parent).transform

	var0_51.anchoredPosition = arg0_51.cells[arg1_51][arg2_51].gameObject.transform.anchoredPosition + Vector2(-5, -4.8)

	local var1_51 = var0_51:GetComponent(typeof(CanvasGroup))

	var1_51.alpha = 1

	if not arg0_51.selectors[arg1_51] then
		arg0_51.selectors[arg1_51] = {}
	end

	arg0_51.selectors[arg1_51][arg2_51] = var1_51
end

function var0_0.CreateBox(arg0_52, arg1_52, arg2_52)
	if not arg0_52.data:ExistBox(arg1_52, arg2_52) or arg0_52.data:IsOpened(arg1_52, arg2_52) then
		return
	end

	local var0_52 = table.getCount(arg0_52.boxes) == 0 and arg0_52.boxTpl or Object.Instantiate(arg0_52.boxTpl, arg0_52.boxTpl.parent).transform
	local var1_52 = var0_52:GetComponent(typeof(CanvasGroup))

	var1_52.alpha = 1
	var0_52.anchoredPosition = arg0_52.cells[arg1_52][arg2_52].gameObject.transform.anchoredPosition

	if not arg0_52.boxes[arg1_52] then
		arg0_52.boxes[arg1_52] = {}
	end

	arg0_52.boxes[arg1_52][arg2_52] = var1_52
end

function var0_0.CreateDrawableArea(arg0_53, arg1_53, arg2_53)
	local var0_53 = arg0_53.data:GetDrawableArea(arg1_53, arg2_53)

	if not var0_53 or arg0_53.data:IsDrawed(arg1_53, arg2_53) then
		return
	end

	local var1_53 = table.getCount(arg0_53.drawableAare) == 0 and arg0_53.areaTpl or Object.Instantiate(arg0_53.areaTpl, arg0_53.areaTpl.parent).transform
	local var2_53 = var0_53[#var0_53] - var0_53[1] + Vector2(1, 1)
	local var3_53 = arg0_53.cells[arg1_53][arg2_53]
	local var4_53 = arg0_53.tpl.sizeDelta * 0.5

	var1_53.anchoredPosition = var3_53.gameObject.transform.anchoredPosition - Vector2(var4_53.x, -var4_53.y)

	local var5_53 = var1_53:GetComponent(typeof(CanvasGroup))

	var5_53.alpha = 1

	if not arg0_53.drawableAare[arg1_53] then
		arg0_53.drawableAare[arg1_53] = {}
	end

	arg0_53.drawableAare[arg1_53][arg2_53] = var5_53
end

function var0_0.UpdateDrawableAreas(arg0_54)
	local var0_54 = arg0_54.data:GetDrawableAreasState()

	for iter0_54, iter1_54 in ipairs(var0_54) do
		local var1_54 = iter1_54.position

		if arg0_54.drawableAare[var1_54.x] and arg0_54.drawableAare[var1_54.x][var1_54.y] then
			arg0_54.drawableAare[var1_54.x][var1_54.y].alpha = iter1_54.open and 1 or 0
		end
	end
end

function var0_0.CreateAnimal(arg0_55, arg1_55, arg2_55, arg3_55, arg4_55)
	if not arg0_55.data:GetDrawableArea(arg1_55, arg2_55) or not arg0_55.data:IsDrawed(arg1_55, arg2_55) then
		return
	end

	local var0_55 = table.getCount(arg0_55.animals) == 0 and arg0_55.animalTpl or Object.Instantiate(arg0_55.animalTpl, arg0_55.animalTpl.parent).transform
	local var1_55 = arg0_55.data:GetDrawAnimData(arg1_55, arg2_55)
	local var2_55 = Vector2(var1_55[2], var1_55[3])

	LoadSpriteAtlasAsync("ui/WorldInPicture_atlas", var1_55[1], function(arg0_56)
		if arg0_55.exited then
			return
		end

		local var0_56 = var0_55:GetComponent(typeof(Image))

		var0_56.sprite = arg0_56

		var0_56:SetNativeSize()

		var0_55.localScale = Vector3(var1_55[4] or 1, var1_55[4] or 1, 1)

		if arg4_55 then
			arg4_55(var0_55)
		end
	end)

	var0_55.localScale = Vector3.zero
	var0_55.localPosition = var2_55

	if not arg0_55.animals[arg1_55] then
		arg0_55.animals[arg1_55] = {}
	end

	local var3_55 = var0_55:GetComponent(typeof(CanvasGroup))

	var3_55.alpha = arg3_55 and 1 or 0
	arg0_55.animals[arg1_55][arg2_55] = var3_55
end

local function var3_0(arg0_57, arg1_57)
	return "<color=#DAC6B3>" .. arg0_57 .. "</color><color=#A38052>/" .. arg1_57 .. "</color>"
end

function var0_0.UpdatePoints(arg0_58)
	arg0_58.travelPointTxt.text = arg0_58.data:GetTravelPoint()
	arg0_58.drawPointTxt.text = arg0_58.data:GetDrawPoint()
	arg0_58.travelProgressTxt.text = var3_0(arg0_58.data:GetTravelProgress(), arg0_58.data:GetMaxTravelCnt())
	arg0_58.drawProgressTxt.text = var3_0(arg0_58.data:GetDrawProgress(), arg0_58.data:GetMaxDrawCnt())
end

function var0_0.DoAnimtion(arg0_59, arg1_59, arg2_59, arg3_59)
	if arg0_59.timer then
		arg0_59.timer:Stop()

		arg0_59.timer = nil
	end

	local function var0_59(arg0_60)
		arg0_59[arg1_59] = arg0_60
		arg0_60.anchoredPosition = arg2_59

		setActive(arg0_60, true)

		arg0_59.timer = Timer.New(function()
			setActive(arg0_60, false)
			arg0_59.timer:Stop()

			arg0_59.timer = nil

			arg3_59()
		end, 0.6, 1)

		arg0_59.timer:Start()
	end

	local var1_59 = arg0_59[arg1_59]

	if not var1_59 then
		arg0_59:LoadEffect(arg1_59, var0_59)
	else
		var0_59(var1_59)
	end
end

function var0_0.GetRedPacket(arg0_62)
	if #arg0_62.redpackets <= 0 then
		local var0_62 = Object.Instantiate(arg0_62.redpacket, arg0_62.redpacket.parent)

		table.insert(arg0_62.redpackets, var0_62.transform)
	end

	local var1_62 = table.remove(arg0_62.redpackets, 1)

	setActive(var1_62, true)

	return var1_62
end

function var0_0.LoadEffect(arg0_63, arg1_63, arg2_63)
	ResourceMgr.Inst:getAssetAsync("UI/" .. arg1_63, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_64)
		if arg0_63.exited then
			return
		end

		arg2_63(Object.Instantiate(arg0_64, arg0_63._tf).transform)
	end), true, true)
end

function var0_0.willExit(arg0_65)
	for iter0_65, iter1_65 in ipairs(arg0_65.redpackets) do
		if LeanTween.isTweening(iter1_65.gameObject) then
			LeanTween.cancel(iter1_65)
		end
	end

	if LeanTween.isTweening(arg0_65.char) then
		LeanTween.cancel(arg0_65.char)
	end

	if arg0_65.timer then
		arg0_65.timer:Stop()

		arg0_65.timer = nil
	end

	Input.multiTouchEnabled = true
end

return var0_0
