local var0_0 = class("SculptureDrawLinePage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SculptureDrawLineUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.cg = GetOrAddComponent(arg0_2._parentTf, typeof(CanvasGroup))
	arg0_2.backBtn = arg0_2:findTF("back")
	arg0_2.helpBtn = arg0_2:findTF("help")
	arg0_2.frame = arg0_2:findTF("frame")
	arg0_2.eventTrigger = arg0_2:findTF("frame"):GetComponent(typeof(EventTriggerListener))
	arg0_2.uiCam = pg.UIMgr.GetInstance().uiCamera:GetComponent("Camera")
	arg0_2.oneKeyBtn = arg0_2.frame:Find("onekey")
	arg0_2.penTpl = arg0_2.frame:Find("pen")

	setText(arg0_2:findTF("tip"), i18n("sculpture_drawline_tip"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.points = {}
	arg0_3.index = 0
end

function var0_0.Show(arg0_4, arg1_4, arg2_4)
	var0_0.super.Show(arg0_4)

	arg0_4.id = arg1_4
	arg0_4.activity = arg2_4

	seriesAsync({
		function(arg0_5)
			arg0_4:Clear()
			arg0_4:InitLine(arg0_5)
		end,
		function(arg0_6)
			arg0_4:InitOneKey(arg0_6)
		end,
		function(arg0_7)
			arg0_4:InitLineRendering()
			arg0_4:RegisterEvent(arg0_7)
		end
	})
	pg.BgmMgr.GetInstance():Push(arg0_4.__cname, "bar-soft")
end

function var0_0.InitLine(arg0_8, arg1_8)
	local var0_8 = arg0_8.activity:GetResorceName(arg0_8.id)

	ResourceMgr.Inst:getAssetAsync("ui/" .. var0_8 .. "_line", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_9)
		arg0_8.tracker = Object.Instantiate(arg0_9, arg0_8.frame).transform
		arg0_8.trackerCollider = arg0_8.tracker:GetComponent("EdgeCollider2D")

		arg1_8()
	end), true, true)
end

function var0_0.InitOneKey(arg0_10, arg1_10)
	local var0_10 = arg0_10.activity:GetResorceName(arg0_10.id)

	ResourceMgr.Inst:getAssetAsync("ui/" .. var0_10 .. "_onekey", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_11)
		local var0_11 = Object.Instantiate(arg0_11, arg0_10.frame).transform

		arg0_10.onekeyTrack = var0_11:GetComponent("EdgeCollider2D")

		arg1_10()
	end), true, true)
end

function var0_0.InitLineRendering(arg0_12)
	arg0_12.eventTrigger:AddPointDownFunc(function(arg0_13, arg1_13)
		arg0_12:OnPointDown(arg1_13)
	end)
	arg0_12.eventTrigger:AddPointUpFunc(function(arg0_14, arg1_14)
		arg0_12:OnPointUp()
	end)
	arg0_12.eventTrigger:AddDragFunc(function(arg0_15, arg1_15)
		arg0_12.index = arg0_12.index + 1

		if arg0_12.index % 5 ~= 0 then
			return
		end

		arg0_12:OnDrag(arg1_15)
	end)
end

function var0_0.OnPointDown(arg0_16, arg1_16)
	arg0_16.points = {}

	arg0_16:AddPoint(arg1_16.position)

	local var0_16 = arg0_16.points[#arg0_16.points]

	arg0_16.pen = Object.Instantiate(arg0_16.penTpl, var0_16, Quaternion.New(0, 0, 0, 0), arg0_16.frame)

	setActive(arg0_16.pen, true)
end

function var0_0.OnPointUp(arg0_17)
	if not arg0_17.pen then
		return
	end

	if #arg0_17.points <= 2 then
		arg0_17.points = {}

		return
	end

	local var0_17 = true

	for iter0_17, iter1_17 in ipairs(arg0_17.points) do
		if not arg0_17.trackerCollider:OverlapPoint(iter1_17) then
			var0_17 = false

			break
		end
	end

	if var0_17 and (#arg0_17.points < 20 or Vector2.Distance(arg0_17.points[1], arg0_17.points[#arg0_17.points]) > 2) then
		var0_17 = false
	end

	if not var0_17 then
		arg0_17.contextData.tipPage:ExecuteAction("Show")
	else
		arg0_17:OnPass()
	end

	Object.Destroy(arg0_17.pen.gameObject)

	arg0_17.pen = nil
end

function var0_0.OnPass(arg0_18)
	arg0_18.contextData.miniMsgBox:ExecuteAction("Show", {
		yes_text = "btn_next",
		effect = true,
		model = true,
		content = i18n("sculpture_drawline_done"),
		onYes = function()
			arg0_18:emit(SculptureMediator.ON_DRAW_SCULPTURE, arg0_18.id)
		end
	})
end

function var0_0.OnDrag(arg0_20, arg1_20)
	if not arg0_20.pen then
		return
	end

	arg0_20:AddPoint(arg1_20.position)

	local var0_20 = arg0_20.points[#arg0_20.points]

	arg0_20.pen.position = var0_20
end

function var0_0.AddPoint(arg0_21, arg1_21)
	local var0_21 = arg0_21.uiCam:ScreenToWorldPoint(arg1_21)
	local var1_21 = Vector3(var0_21.x, var0_21.y, -1)

	table.insert(arg0_21.points, var1_21)
end

function var0_0.RegisterEvent(arg0_22, arg1_22)
	onButton(arg0_22, arg0_22.backBtn, function()
		arg0_22.contextData.miniMsgBox:ExecuteAction("Show", {
			showNo = true,
			content = i18n("sculpture_drawline_exit"),
			onYes = function()
				arg0_22:Hide()
			end
		})
	end, SFX_PANEL)
	onButton(arg0_22, arg0_22.oneKeyBtn, function()
		arg0_22:OnOneKey()
	end, SFX_PANEL)
	onButton(arg0_22, arg0_22.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.gift_act_help.tip
		})
	end, SFX_PANEL)
end

function var0_0.OnOneKey(arg0_27)
	arg0_27.points = {}

	local var0_27 = arg0_27.onekeyTrack.points

	for iter0_27 = 1, var0_27.Length do
		local var1_27 = var0_27[iter0_27 - 1]
		local var2_27 = arg0_27.tracker:TransformPoint(var1_27)
		local var3_27 = Vector3(var2_27.x, var2_27.y, -1)

		table.insert(arg0_27.points, var3_27)
	end

	local function var4_27(arg0_28)
		if not arg0_27.pen then
			arg0_27.pen = Object.Instantiate(arg0_27.penTpl, arg0_28, Quaternion.New(0, 0, 0, 0), arg0_27.frame)
		else
			arg0_27.pen.position = arg0_28
		end
	end

	local var5_27 = {}

	for iter1_27 = 1, #arg0_27.points do
		table.insert(var5_27, function(arg0_29)
			var4_27(arg0_27.points[iter1_27])
			onNextTick(arg0_29)
		end)
	end

	arg0_27.cg.blocksRaycasts = false

	seriesAsync(var5_27, function()
		arg0_27:OnPass()

		arg0_27.cg.blocksRaycasts = true

		if arg0_27.pen then
			Object.Destroy(arg0_27.pen.gameObject)

			arg0_27.pen = nil
		end
	end)
end

function var0_0.Clear(arg0_31)
	if not IsNil(arg0_31.tracker) then
		Object.Destroy(arg0_31.tracker.gameObject)
	end

	arg0_31.points = {}
	arg0_31.tracker = nil

	removeOnButton(arg0_31.oneKeyBtn)
end

function var0_0.Hide(arg0_32)
	var0_0.super.Hide(arg0_32)
	pg.BgmMgr.GetInstance():Pop(arg0_32.__cname)
	arg0_32:Clear()
end

function var0_0.OnDestroy(arg0_33)
	arg0_33.exited = true
end

return var0_0
