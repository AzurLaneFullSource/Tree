local var0 = class("SculptureDrawLinePage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "SculptureDrawLineUI"
end

function var0.OnLoaded(arg0)
	arg0.cg = GetOrAddComponent(arg0._parentTf, typeof(CanvasGroup))
	arg0.backBtn = arg0:findTF("back")
	arg0.helpBtn = arg0:findTF("help")
	arg0.frame = arg0:findTF("frame")
	arg0.eventTrigger = arg0:findTF("frame"):GetComponent(typeof(EventTriggerListener))
	arg0.uiCam = pg.UIMgr.GetInstance().uiCamera:GetComponent("Camera")
	arg0.oneKeyBtn = arg0.frame:Find("onekey")
	arg0.penTpl = arg0.frame:Find("pen")

	setText(arg0:findTF("tip"), i18n("sculpture_drawline_tip"))
end

function var0.OnInit(arg0)
	arg0.points = {}
	arg0.index = 0
end

function var0.Show(arg0, arg1, arg2)
	var0.super.Show(arg0)

	arg0.id = arg1
	arg0.activity = arg2

	seriesAsync({
		function(arg0)
			arg0:Clear()
			arg0:InitLine(arg0)
		end,
		function(arg0)
			arg0:InitOneKey(arg0)
		end,
		function(arg0)
			arg0:InitLineRendering()
			arg0:RegisterEvent(arg0)
		end
	})
	pg.BgmMgr.GetInstance():Push(arg0.__cname, "bar-soft")
end

function var0.InitLine(arg0, arg1)
	local var0 = arg0.activity:GetResorceName(arg0.id)

	ResourceMgr.Inst:getAssetAsync("ui/" .. var0 .. "_line", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		arg0.tracker = Object.Instantiate(arg0, arg0.frame).transform
		arg0.trackerCollider = arg0.tracker:GetComponent("EdgeCollider2D")

		arg1()
	end), true, true)
end

function var0.InitOneKey(arg0, arg1)
	local var0 = arg0.activity:GetResorceName(arg0.id)

	ResourceMgr.Inst:getAssetAsync("ui/" .. var0 .. "_onekey", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		local var0 = Object.Instantiate(arg0, arg0.frame).transform

		arg0.onekeyTrack = var0:GetComponent("EdgeCollider2D")

		arg1()
	end), true, true)
end

function var0.InitLineRendering(arg0)
	arg0.eventTrigger:AddPointDownFunc(function(arg0, arg1)
		arg0:OnPointDown(arg1)
	end)
	arg0.eventTrigger:AddPointUpFunc(function(arg0, arg1)
		arg0:OnPointUp()
	end)
	arg0.eventTrigger:AddDragFunc(function(arg0, arg1)
		arg0.index = arg0.index + 1

		if arg0.index % 5 ~= 0 then
			return
		end

		arg0:OnDrag(arg1)
	end)
end

function var0.OnPointDown(arg0, arg1)
	arg0.points = {}

	arg0:AddPoint(arg1.position)

	local var0 = arg0.points[#arg0.points]

	arg0.pen = Object.Instantiate(arg0.penTpl, var0, Quaternion.New(0, 0, 0, 0), arg0.frame)

	setActive(arg0.pen, true)
end

function var0.OnPointUp(arg0)
	if not arg0.pen then
		return
	end

	if #arg0.points <= 2 then
		arg0.points = {}

		return
	end

	local var0 = true

	for iter0, iter1 in ipairs(arg0.points) do
		if not arg0.trackerCollider:OverlapPoint(iter1) then
			var0 = false

			break
		end
	end

	if var0 and (#arg0.points < 20 or Vector2.Distance(arg0.points[1], arg0.points[#arg0.points]) > 2) then
		var0 = false
	end

	if not var0 then
		arg0.contextData.tipPage:ExecuteAction("Show")
	else
		arg0:OnPass()
	end

	Object.Destroy(arg0.pen.gameObject)

	arg0.pen = nil
end

function var0.OnPass(arg0)
	arg0.contextData.miniMsgBox:ExecuteAction("Show", {
		yes_text = "btn_next",
		effect = true,
		model = true,
		content = i18n("sculpture_drawline_done"),
		onYes = function()
			arg0:emit(SculptureMediator.ON_DRAW_SCULPTURE, arg0.id)
		end
	})
end

function var0.OnDrag(arg0, arg1)
	if not arg0.pen then
		return
	end

	arg0:AddPoint(arg1.position)

	local var0 = arg0.points[#arg0.points]

	arg0.pen.position = var0
end

function var0.AddPoint(arg0, arg1)
	local var0 = arg0.uiCam:ScreenToWorldPoint(arg1)
	local var1 = Vector3(var0.x, var0.y, -1)

	table.insert(arg0.points, var1)
end

function var0.RegisterEvent(arg0, arg1)
	onButton(arg0, arg0.backBtn, function()
		arg0.contextData.miniMsgBox:ExecuteAction("Show", {
			showNo = true,
			content = i18n("sculpture_drawline_exit"),
			onYes = function()
				arg0:Hide()
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.oneKeyBtn, function()
		arg0:OnOneKey()
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.gift_act_help.tip
		})
	end, SFX_PANEL)
end

function var0.OnOneKey(arg0)
	arg0.points = {}

	local var0 = arg0.onekeyTrack.points

	for iter0 = 1, var0.Length do
		local var1 = var0[iter0 - 1]
		local var2 = arg0.tracker:TransformPoint(var1)
		local var3 = Vector3(var2.x, var2.y, -1)

		table.insert(arg0.points, var3)
	end

	local function var4(arg0)
		if not arg0.pen then
			arg0.pen = Object.Instantiate(arg0.penTpl, arg0, Quaternion.New(0, 0, 0, 0), arg0.frame)
		else
			arg0.pen.position = arg0
		end
	end

	local var5 = {}

	for iter1 = 1, #arg0.points do
		table.insert(var5, function(arg0)
			var4(arg0.points[iter1])
			onNextTick(arg0)
		end)
	end

	arg0.cg.blocksRaycasts = false

	seriesAsync(var5, function()
		arg0:OnPass()

		arg0.cg.blocksRaycasts = true

		if arg0.pen then
			Object.Destroy(arg0.pen.gameObject)

			arg0.pen = nil
		end
	end)
end

function var0.Clear(arg0)
	if not IsNil(arg0.tracker) then
		Object.Destroy(arg0.tracker.gameObject)
	end

	arg0.points = {}
	arg0.tracker = nil

	removeOnButton(arg0.oneKeyBtn)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.BgmMgr.GetInstance():Pop(arg0.__cname)
	arg0:Clear()
end

function var0.OnDestroy(arg0)
	arg0.exited = true
end

return var0
