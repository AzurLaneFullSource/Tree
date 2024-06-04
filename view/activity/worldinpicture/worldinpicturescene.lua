local var0 = class("WorldInPictureScene", import("...base.BaseUI"))
local var1 = 0
local var2 = 1

function var0.getUIName(arg0)
	return "WorldInPictureUI"
end

function var0.emit(arg0, ...)
	if arg0.inAniming then
		return
	end

	var0.super.emit(arg0, ...)
end

function var0.OnOpenCellErro(arg0, arg1)
	if arg1 then
		arg0.onkeyTravelProcess = false

		arg0:UpdateTravelBtnState()
	end
end

function var0.OnOpenCell(arg0, arg1, arg2, arg3)
	arg0:CloseSelector(arg1, arg2)
	arg0:HideBox(arg1, arg2)

	arg0.inAniming = true

	local var0 = arg0.cells[arg1][arg2]
	local var1 = var0.gameObject.transform.anchoredPosition

	arg0:DoAnimtion("picture_faguang", var1, function()
		var0.alpha = 1

		if arg3 and arg0.data:ExistBox(arg1, arg2) then
			arg0:RpAnim(arg1, arg2)
		end

		arg0:HightLightOpenArea(arg1, arg2)
		arg0:UpdatePoints()
		arg0:UpdateSwitcherState()

		local var0 = arg0.data:IsFirstTravel()

		arg0:UpdateChar(Vector2(arg1, arg2), not var0)
		arg0:SaveCharPosition(arg1, arg2)

		arg0.inAniming = false
		arg0.forceStopTravelPorcess = false

		if arg3 then
			local var1 = arg0.onkeyTravelProcess

			arg0.onkeyTravelProcess = false

			arg0:UpdateTravelBtnState()

			if not var1 or not arg0.data:FindNextTravelable() then
				arg0:emit(WorldInPictureMediator.RESULT_ONEKEY_AWARD)
			elseif var1 == true then
				triggerButton(arg0.onekeyTravelBtn)
			end
		end
	end)
end

function var0.CloseSelector(arg0, arg1, arg2)
	if arg0.data:IsFirstTravel() then
		for iter0, iter1 in ipairs(arg0.selectors) do
			for iter2, iter3 in ipairs(iter1) do
				iter3.alpha = 0
			end
		end
	else
		local var0 = arg0.selectors[arg1][arg2]

		if var0 and var0.alpha ~= 0 then
			var0.alpha = 0
		end
	end
end

function var0.HightLightOpenArea(arg0, arg1, arg2)
	local var0 = {
		Vector2(arg1 + 1, arg2),
		Vector2(arg1, arg2 + 1),
		Vector2(arg1 - 1, arg2),
		Vector2(arg1, arg2 - 1)
	}

	local function var1(arg0)
		if arg0.data:IsOpened(arg0.x, arg0.y) or arg0.data:OutSide(arg0.x, arg0.y) then
			return
		end

		if not arg0.selectors[arg0.x] or not arg0.selectors[arg0.x][arg0.y] then
			arg0:CreateSelector(arg0.x, arg0.y)
		else
			arg0.selectors[arg0.x][arg0.y].alpha = 1
		end
	end

	_.each(var0, var1)
end

function var0.RpAnim(arg0, arg1, arg2)
	local var0 = arg0:GetRedPacket()

	var0.anchoredPosition = arg0.cells[arg1][arg2].gameObject.transform.anchoredPosition + Vector2(48, 48)

	LeanTween.value(var0.gameObject, var0.anchoredPosition.y, var0.anchoredPosition.y + 35, 0.75):setOnUpdate(System.Action_float(function(arg0)
		var0.anchoredPosition = Vector2(var0.anchoredPosition.x, arg0)
	end)):setOnComplete(System.Action(function()
		if arg0.exited then
			return
		end

		setActive(var0, false)
		table.insert(arg0.redpackets, var0)
	end))
end

function var0.HideBox(arg0, arg1, arg2)
	local var0

	if arg0.boxes[arg1] then
		var0 = arg0.boxes[arg1][arg2]
	end

	if var0 then
		var0.alpha = 0
	end
end

function var0.OnDrawAreaErro(arg0, arg1)
	if arg1 then
		arg0.onkeyDrawPorcess = false

		arg0:UpdateDrawBtnState()
	end
end

function var0.OnDrawArea(arg0, arg1, arg2, arg3)
	arg0:HideDrawarea(arg1, arg2)

	arg0.inAniming = true

	arg0:CreateAnimal(arg1, arg2, false, function(arg0)
		local var0 = arg0.data:GetDrawAnimData(arg1, arg2)
		local var1 = arg0.sizeDelta.x * arg0.localScale.x * 0.5 + 90
		local var2 = arg0.sizeDelta.y * arg0.localScale.y * 0.5
		local var3 = Vector2(var0[2] + var1, var0[3] - var2)

		arg0:DoAnimtion("picture_bichu", var3, function()
			LeanTween.value(arg0.gameObject, 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0)
				if arg0.exited then
					return
				end

				arg0:GetComponent(typeof(CanvasGroup)).alpha = arg0
			end))
			arg0:UpdatePoints()

			arg0.inAniming = false
			arg0.forceStopDrawPorcess = false

			if arg3 then
				local var0 = arg0.onkeyDrawPorcess

				arg0.onkeyDrawPorcess = false

				arg0:UpdateDrawBtnState()

				if not var0 or not arg0.data:FindNextDrawableAreaHead() then
					arg0:emit(WorldInPictureMediator.RESULT_ONEKEY_AWARD)
				elseif arg3 and var0 == true then
					triggerButton(arg0.onekeyDrawBtn)
				end
			end
		end)
	end)
end

function var0.HideDrawarea(arg0, arg1, arg2)
	local var0

	if arg0.drawableAare[arg1] then
		var0 = arg0.drawableAare[arg1][arg2]
	end

	if var0 then
		var0.alpha = 0
	end
end

function var0.SetData(arg0, arg1)
	arg0.data = arg1
end

function var0.init(arg0)
	Input.multiTouchEnabled = false
	arg0.redpacket = arg0:findTF("redpackets/redpacket")
	arg0.lineHrzTpl = arg0:findTF("lines/line_hrz")
	arg0.lineVecTpl = arg0:findTF("lines/line_vec")
	arg0.animalTpl = arg0:findTF("animals/animal")
	arg0.areaTpl = arg0:findTF("drawablearea/area")
	arg0.boxTpl = arg0:findTF("boxes/box")
	arg0.selectorTpl = arg0:findTF("selectors/selector")
	arg0.tpl = arg0:findTF("grids/grid")
	arg0.backBtn = arg0:findTF("back")
	arg0.helpBtn = arg0:findTF("help")
	arg0.travelPointTxt = arg0:findTF("points/travel"):GetComponent(typeof(Text))
	arg0.drawPointTxt = arg0:findTF("points/draw"):GetComponent(typeof(Text))
	arg0.travelProgressTxt = arg0:findTF("progress/travel"):GetComponent(typeof(Text))
	arg0.drawProgressTxt = arg0:findTF("progress/draw"):GetComponent(typeof(Text))
	arg0.switchBtn = arg0:findTF("swticher")
	arg0.onDisable = arg0.switchBtn:Find("on_disable")
	arg0.btnOn = arg0.switchBtn:Find("on_enable/draw")
	arg0.btnOff = arg0.switchBtn:Find("on_enable/off")
	arg0.onekeyTravelBtn = arg0:findTF("onekey_travel")
	arg0.onekeyTravelingBtn = arg0:findTF("onekey_travel/Image")
	arg0.onekeyDrawBtn = arg0:findTF("onekey_draw")
	arg0.onekeyDrawingBtn = arg0:findTF("onekey_draw/Image")
	arg0.char = arg0:findTF("char/char")

	setActive(arg0.char, false)

	arg0.selectorContainer = arg0:findTF("selectors"):GetComponent(typeof(CanvasGroup))
	arg0.drawableAreaContainer = arg0:findTF("drawablearea"):GetComponent(typeof(CanvasGroup))
	arg0.startPos = arg0.tpl.anchoredPosition
	arg0.offset = Vector2(0.5, 0.5)
	arg0.width = arg0.tpl.sizeDelta.x
	arg0.height = arg0.tpl.sizeDelta.y
	arg0.cells = {}
	arg0.selectors = {}
	arg0.boxes = {}
	arg0.drawableAare = {}
	arg0.animals = {}
	arg0.redpackets = {
		arg0.redpacket
	}
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		if arg0.opType == var1 and arg0.onkeyTravelProcess then
			arg0.onkeyTravelProcess = false

			arg0:UpdateTravelBtnState()

			return
		elseif arg0.opType == var2 and arg0.onkeyDrawPorcess then
			arg0.onkeyDrawPorcess = false

			arg0:UpdateDrawBtnState()

			return
		end

		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.worldinpicture_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.onekeyTravelBtn, function()
		if arg0.forceStopTravelPorcess then
			return
		end

		if arg0.data:IsTravelAll() then
			return
		end

		if arg0.data:GetTravelPoint() <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("worldinpicture_tavel_point_tip"))

			return
		end

		if arg0.onkeyTravelProcess then
			arg0.onkeyTravelProcess = false
			arg0.forceStopTravelPorcess = true

			arg0:UpdateTravelBtnState()

			return
		end

		local var0, var1 = arg0.data:FindNextTravelable()

		if var0 and var1 then
			arg0.onkeyTravelProcess = true

			arg0:UpdateTravelBtnState()
			arg0:emit(WorldInPictureMediator.ON_AUTO_TRAVEL, var0.x, var0.y, var1)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.onekeyDrawBtn, function()
		if arg0.forceStopDrawPorcess then
			return
		end

		if arg0.data:IsDrawAll() then
			return
		end

		if arg0.data:GetDrawPoint() <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("worldinpicture_draw_point_tip"))

			return
		end

		if arg0.onkeyDrawPorcess then
			arg0.onkeyDrawPorcess = false
			arg0.forceStopDrawPorcess = true

			arg0:UpdateDrawBtnState()

			return
		end

		local var0, var1 = arg0.data:FindNextDrawableAreaHead()

		if var0 and var1 then
			arg0.onkeyDrawPorcess = true

			arg0:UpdateDrawBtnState()
			arg0:emit(WorldInPictureMediator.ON_AUTO_DRAW, var0.x, var0.y, var1)
		end
	end, SFX_PANEL)

	arg0.opType = var1

	onButton(arg0, arg0.onDisable, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("worldinpicture_not_area_can_draw"))
	end, SFX_PANEL)
	onButton(arg0, arg0.btnOn, function()
		if arg0.opType == var1 and arg0.onkeyTravelProcess then
			arg0.onkeyTravelProcess = false

			arg0:UpdateTravelBtnState()

			return
		elseif arg0.opType == var2 and arg0.onkeyDrawPorcess then
			arg0.onkeyDrawPorcess = false

			arg0:UpdateDrawBtnState()

			return
		end

		if arg0.inAniming then
			return
		end

		arg0.opType = var2

		arg0:UpdateSwitcherState()
	end, SFX_PANEL)
	onButton(arg0, arg0.btnOff, function()
		if arg0.opType == var1 and arg0.onkeyTravelProcess then
			arg0.onkeyTravelProcess = false

			arg0:UpdateTravelBtnState()

			return
		elseif arg0.opType == var2 and arg0.onkeyDrawPorcess then
			arg0.onkeyDrawPorcess = false

			arg0:UpdateDrawBtnState()

			return
		end

		if arg0.inAniming then
			return
		end

		arg0.opType = var1

		arg0:UpdateSwitcherState()
	end, SFX_PANEL)
	arg0:UpdateSwitcherState()
	arg0:InitView()
end

function var0.UpdateDrawBtnState(arg0)
	setActive(arg0.onekeyDrawingBtn, arg0.onkeyDrawPorcess)
end

function var0.UpdateTravelBtnState(arg0)
	setActive(arg0.onekeyTravelingBtn, arg0.onkeyTravelProcess)
end

function var0.GetRecordCharPos(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = PlayerPrefs.GetString("WorldInPictureScene_1" .. var0, "0#0")
	local var2 = string.split(var1, "#")

	return Vector2(tonumber(var2[1]), tonumber(var2[2]))
end

function var0.SaveCharPosition(arg0, arg1, arg2)
	local var0 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString("WorldInPictureScene_1" .. var0, arg1 .. "#" .. arg2)
	PlayerPrefs.Save()
end

function var0.moveChar(arg0, arg1, arg2, arg3)
	if LeanTween.isTweening(go(arg0.char)) then
		LeanTween.cancel(go(arg0.char))
	end

	if isActive(arg0.char) then
		arg0:hideChar(function()
			arg0:showChar(arg1, arg2, arg3)
		end)
	else
		arg0:showChar(arg1, arg2, arg3)
	end
end

function var0.showChar(arg0, arg1, arg2, arg3)
	arg0.char.transform.localPosition = Vector3(arg1, arg2 + 50)

	setActive(arg0.char, true)
	LeanTween.value(go(arg0.char), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0)
		GetOrAddComponent(arg0.char, typeof(CanvasGroup)).alpha = arg0
	end))
	LeanTween.moveLocal(go(arg0.char), Vector3(arg1, arg2, 0), 0.2):setOnComplete(System.Action(function()
		if arg3 then
			arg3()
		end
	end))
end

function var0.hideChar(arg0, arg1)
	LeanTween.value(go(arg0.char), 1, 0, 0.2):setOnUpdate(System.Action_float(function(arg0)
		GetOrAddComponent(arg0.char, typeof(CanvasGroup)).alpha = arg0
	end))

	local var0 = arg0.char.transform.localPosition

	LeanTween.moveLocal(go(arg0.char), Vector3(var0.x, var0.y + 50, 0), 0.2):setOnComplete(System.Action(function()
		setActive(arg0.char, false)

		if arg1 then
			arg1()
		end
	end))
end

function var0.UpdateChar(arg0, arg1, arg2)
	if arg1 == Vector2.zero then
		setActive(arg0.char, false)

		return
	end

	if LeanTween.isTweening(arg0.char) then
		LeanTween.cancel(arg0.char)
	end

	if arg0.data:IsTravelAll() then
		setActive(arg0.char, false)

		return
	end

	local var0 = arg0.cells[arg1.x][arg1.y].gameObject.transform.anchoredPosition
	local var1 = Vector2(var0.x, var0.y - 50)

	if arg2 then
		arg0:moveChar(var1.x, var1.y, function()
			return
		end)
	else
		arg0.char.transform.localPosition = var1
	end
end

function var0.UpdateSwitcherState(arg0)
	local var0 = arg0.opType == var2
	local var1 = arg0.data:AnyAreaCanDraw()

	setActive(arg0.btnOff, var0)
	setActive(arg0.onDisable, not var0 and not var1)
	setActive(arg0.btnOn, not var0 and var1)
	setActive(arg0.onekeyTravelBtn, not var0)
	setActive(arg0.onekeyDrawBtn, var0)
	setActive(arg0.char, not var0 and not arg0.data:IsTravelAll())

	arg0.selectorContainer.alpha = var0 and 0 or 1
	arg0.drawableAreaContainer.alpha = var0 and 1 or 0

	if var0 then
		arg0:UpdateDrawableAreas()
	end
end

function var0.InitView(arg0)
	local var0, var1 = arg0.data:GetMapRowAndColumn()
	local var2 = {}

	for iter0 = 1, var0 do
		table.insert(var2, function(arg0)
			for iter0 = var1, 1, -1 do
				arg0:CreateCell(iter0, iter0, (iter0 - 1) * var1 + iter0)
			end

			onNextTick(arg0)
		end)
	end

	seriesAsync(var2, function()
		arg0:InitLines()
		arg0:UpdateChar(arg0:GetRecordCharPos())
	end)
	arg0:UpdatePoints()
end

function var0.InitLines(arg0)
	local var0, var1 = arg0.data:GetMapRowAndColumn()
	local var2 = arg0.tpl.sizeDelta.y * var0 + 10

	for iter0 = 1, var1 - 1 do
		local var3 = iter0 == 1 and arg0.lineVecTpl or Object.Instantiate(arg0.lineVecTpl, arg0.lineVecTpl.parent)

		var3.sizeDelta = Vector2(var3.sizeDelta.x, var2)

		local var4 = arg0.cells[1][iter0]
		local var5 = var4.gameObject.transform.anchoredPosition.x + var4.gameObject.transform.sizeDelta.x * 0.5

		var3.anchoredPosition = Vector2(var5 + arg0.offset.x, var3.anchoredPosition.y)
	end

	local var6 = arg0.tpl.sizeDelta.x * var1 + 20

	for iter1 = 1, var0 - 1 do
		local var7 = iter1 == 1 and arg0.lineHrzTpl or Object.Instantiate(arg0.lineHrzTpl, arg0.lineHrzTpl.parent)

		var7.sizeDelta = Vector2(var7.sizeDelta.x, var6)

		local var8 = arg0.cells[iter1][1]
		local var9 = var8.gameObject.transform.anchoredPosition.y - var8.gameObject.transform.sizeDelta.y * 0.5

		var7.anchoredPosition = Vector2(var7.anchoredPosition.x, var9 + arg0.offset.y)
	end
end

function var0.CreateCell(arg0, arg1, arg2, arg3)
	if arg0.exited then
		return
	end

	local var0 = arg2 == 1 and arg1 == 1 and arg0.tpl or Object.Instantiate(arg0.tpl, arg0.tpl.parent).transform
	local var1 = arg0.startPos.x + (arg2 - 1) * (arg0.width + arg0.offset.x)
	local var2 = arg0.startPos.y - (arg1 - 1) * (arg0.height + arg0.offset.y)

	LoadSpriteAtlasAsync("ui/WorldInPicture_atlas", "view_" .. arg3 - 1, function(arg0)
		if arg0.exited then
			return
		end

		local var0 = var0:GetComponent(typeof(Image))

		var0.sprite = arg0

		var0:SetNativeSize()

		var0.anchoredPosition = Vector2(var1, var2)

		arg0:CreateSelector(arg1, arg2)
		arg0:CreateBox(arg1, arg2)
		arg0:CreateDrawableArea(arg1, arg2)
		arg0:CreateAnimal(arg1, arg2, true)
	end)

	if not arg0.cells[arg1] then
		arg0.cells[arg1] = {}
	end

	onButton(arg0, var0, function()
		if arg0.opType == var1 then
			if arg0.onkeyTravelProcess then
				arg0.onkeyTravelProcess = false

				arg0:UpdateTravelBtnState()

				return
			end

			if arg0.data:IsTravelAll() then
				return
			end

			if arg0.data:GetTravelPoint() <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("worldinpicture_tavel_point_tip"))

				return
			end

			if arg0.data:CanSelect(arg1, arg2) then
				arg0:emit(WorldInPictureMediator.ON_TRAVEL, arg1, arg2, arg3)
			end
		elseif arg0.opType == var2 then
			if arg0.onkeyDrawPorcess then
				arg0.onkeyDrawPorcess = false

				arg0:UpdateDrawBtnState()

				return
			end

			if arg0.data:IsDrawAll() then
				return
			end

			if arg0.data:GetDrawPoint() <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("worldinpicture_draw_point_tip"))

				return
			end

			if arg0.data:CanDraw(arg1, arg2) then
				local var0, var1, var2 = arg0.data:Convert2DrawAreaHead(arg1, arg2)

				arg0:emit(WorldInPictureMediator.ON_DRAW, var0, var1, var2)
			end
		end
	end, SFX_PANEL)

	local var3 = var0:GetComponent(typeof(CanvasGroup))

	var3.alpha = arg0.data:IsOpened(arg1, arg2) and 1 or 0
	arg0.cells[arg1][arg2] = var3
end

function var0.CreateSelector(arg0, arg1, arg2)
	if not arg0.data:CanSelect(arg1, arg2) then
		return
	end

	local var0 = table.getCount(arg0.selectors) == 0 and arg0.selectorTpl or Object.Instantiate(arg0.selectorTpl, arg0.selectorTpl.parent).transform

	var0.anchoredPosition = arg0.cells[arg1][arg2].gameObject.transform.anchoredPosition + Vector2(-5, -4.8)

	local var1 = var0:GetComponent(typeof(CanvasGroup))

	var1.alpha = 1

	if not arg0.selectors[arg1] then
		arg0.selectors[arg1] = {}
	end

	arg0.selectors[arg1][arg2] = var1
end

function var0.CreateBox(arg0, arg1, arg2)
	if not arg0.data:ExistBox(arg1, arg2) or arg0.data:IsOpened(arg1, arg2) then
		return
	end

	local var0 = table.getCount(arg0.boxes) == 0 and arg0.boxTpl or Object.Instantiate(arg0.boxTpl, arg0.boxTpl.parent).transform
	local var1 = var0:GetComponent(typeof(CanvasGroup))

	var1.alpha = 1
	var0.anchoredPosition = arg0.cells[arg1][arg2].gameObject.transform.anchoredPosition

	if not arg0.boxes[arg1] then
		arg0.boxes[arg1] = {}
	end

	arg0.boxes[arg1][arg2] = var1
end

function var0.CreateDrawableArea(arg0, arg1, arg2)
	local var0 = arg0.data:GetDrawableArea(arg1, arg2)

	if not var0 or arg0.data:IsDrawed(arg1, arg2) then
		return
	end

	local var1 = table.getCount(arg0.drawableAare) == 0 and arg0.areaTpl or Object.Instantiate(arg0.areaTpl, arg0.areaTpl.parent).transform
	local var2 = var0[#var0] - var0[1] + Vector2(1, 1)
	local var3 = arg0.cells[arg1][arg2]
	local var4 = arg0.tpl.sizeDelta * 0.5

	var1.anchoredPosition = var3.gameObject.transform.anchoredPosition - Vector2(var4.x, -var4.y)

	local var5 = var1:GetComponent(typeof(CanvasGroup))

	var5.alpha = 1

	if not arg0.drawableAare[arg1] then
		arg0.drawableAare[arg1] = {}
	end

	arg0.drawableAare[arg1][arg2] = var5
end

function var0.UpdateDrawableAreas(arg0)
	local var0 = arg0.data:GetDrawableAreasState()

	for iter0, iter1 in ipairs(var0) do
		local var1 = iter1.position

		if arg0.drawableAare[var1.x] and arg0.drawableAare[var1.x][var1.y] then
			arg0.drawableAare[var1.x][var1.y].alpha = iter1.open and 1 or 0
		end
	end
end

function var0.CreateAnimal(arg0, arg1, arg2, arg3, arg4)
	if not arg0.data:GetDrawableArea(arg1, arg2) or not arg0.data:IsDrawed(arg1, arg2) then
		return
	end

	local var0 = table.getCount(arg0.animals) == 0 and arg0.animalTpl or Object.Instantiate(arg0.animalTpl, arg0.animalTpl.parent).transform
	local var1 = arg0.data:GetDrawAnimData(arg1, arg2)
	local var2 = Vector2(var1[2], var1[3])

	LoadSpriteAtlasAsync("ui/WorldInPicture_atlas", var1[1], function(arg0)
		if arg0.exited then
			return
		end

		local var0 = var0:GetComponent(typeof(Image))

		var0.sprite = arg0

		var0:SetNativeSize()

		var0.localScale = Vector3(var1[4] or 1, var1[4] or 1, 1)

		if arg4 then
			arg4(var0)
		end
	end)

	var0.localScale = Vector3.zero
	var0.localPosition = var2

	if not arg0.animals[arg1] then
		arg0.animals[arg1] = {}
	end

	local var3 = var0:GetComponent(typeof(CanvasGroup))

	var3.alpha = arg3 and 1 or 0
	arg0.animals[arg1][arg2] = var3
end

local function var3(arg0, arg1)
	return "<color=#DAC6B3>" .. arg0 .. "</color><color=#A38052>/" .. arg1 .. "</color>"
end

function var0.UpdatePoints(arg0)
	arg0.travelPointTxt.text = arg0.data:GetTravelPoint()
	arg0.drawPointTxt.text = arg0.data:GetDrawPoint()
	arg0.travelProgressTxt.text = var3(arg0.data:GetTravelProgress(), arg0.data:GetMaxTravelCnt())
	arg0.drawProgressTxt.text = var3(arg0.data:GetDrawProgress(), arg0.data:GetMaxDrawCnt())
end

function var0.DoAnimtion(arg0, arg1, arg2, arg3)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	local function var0(arg0)
		arg0[arg1] = arg0
		arg0.anchoredPosition = arg2

		setActive(arg0, true)

		arg0.timer = Timer.New(function()
			setActive(arg0, false)
			arg0.timer:Stop()

			arg0.timer = nil

			arg3()
		end, 0.6, 1)

		arg0.timer:Start()
	end

	local var1 = arg0[arg1]

	if not var1 then
		arg0:LoadEffect(arg1, var0)
	else
		var0(var1)
	end
end

function var0.GetRedPacket(arg0)
	if #arg0.redpackets <= 0 then
		local var0 = Object.Instantiate(arg0.redpacket, arg0.redpacket.parent)

		table.insert(arg0.redpackets, var0.transform)
	end

	local var1 = table.remove(arg0.redpackets, 1)

	setActive(var1, true)

	return var1
end

function var0.LoadEffect(arg0, arg1, arg2)
	ResourceMgr.Inst:getAssetAsync("UI/" .. arg1, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.exited then
			return
		end

		arg2(Object.Instantiate(arg0, arg0._tf).transform)
	end), true, true)
end

function var0.willExit(arg0)
	for iter0, iter1 in ipairs(arg0.redpackets) do
		if LeanTween.isTweening(iter1.gameObject) then
			LeanTween.cancel(iter1)
		end
	end

	if LeanTween.isTweening(arg0.char) then
		LeanTween.cancel(arg0.char)
	end

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	Input.multiTouchEnabled = true
end

return var0
