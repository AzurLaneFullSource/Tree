local var0_0 = class("NewStoryRecordPanel")
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2
local var4_0 = 3
local var5_0 = 4
local var6_0 = 5
local var7_0 = 10

function var0_0.GetUIName(arg0_1)
	return "NewStoryRecordUI"
end

function var0_0.Ctor(arg0_2)
	arg0_2.state = var1_0
end

function var0_0.Load(arg0_3)
	arg0_3.state = var2_0
	arg0_3.parentTF = arg0_3:GetParent()

	ResourceMgr.Inst:getAssetAsync("ui/" .. arg0_3:GetUIName(), "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_4)
		local var0_4 = Object.Instantiate(arg0_4, arg0_3.parentTF)

		if arg0_3:IsLoading() then
			arg0_3.state = var3_0

			arg0_3:Init(var0_4)
		end
	end), true, true)
end

function var0_0.GetParent(arg0_5)
	return pg.NewStoryMgr.GetInstance().frontTr
end

function var0_0.IsEmptyOrUnload(arg0_6)
	return arg0_6.state == var1_0 or arg0_6.state == var6_0
end

function var0_0.IsLoading(arg0_7)
	return arg0_7.state == var2_0
end

function var0_0.IsShowing(arg0_8)
	return arg0_8.state == var4_0
end

function var0_0.CanOpen(arg0_9)
	return arg0_9.state == var1_0 or arg0_9.state == var5_0 or arg0_9.state == var6_0
end

function var0_0.Init(arg0_10, arg1_10)
	arg0_10._go = arg1_10
	arg0_10._tf = arg1_10.transform
	arg0_10.pageAnim = arg0_10._tf:GetComponent(typeof(Animation))
	arg0_10.pageAniEvent = arg0_10._tf:GetComponent(typeof(DftAniEvent))
	arg0_10.container = arg0_10._tf:Find("content")
	arg0_10.tpl = arg0_10._tf:Find("content/tpl")
	arg0_10.cg = GetOrAddComponent(arg0_10._tf, typeof(CanvasGroup))
	arg0_10.tplPools = {
		arg0_10.tpl
	}
	arg0_10.closeBtn = arg0_10._tf:Find("close")
	arg0_10.bgImage = arg0_10._tf:GetComponent(typeof(Image))
	arg0_10.scrollrect = arg0_10._tf:GetComponent(typeof(ScrollRect))
	arg0_10.contentSizeFitter = arg0_10._tf:Find("content"):GetComponent(typeof(ContentSizeFitter))

	onButton(nil, arg0_10.closeBtn, function()
		setButtonEnabled(arg0_10.closeBtn, false)
		arg0_10:Hide()
	end, SFX_PANEL)
	arg0_10.pageAniEvent:SetEndEvent(function()
		arg0_10:OnHide()
	end)

	arg0_10.state = var4_0

	arg0_10:UpdateAll()
end

function var0_0.UpdateAll(arg0_13)
	arg0_13.cg.blocksRaycasts = false

	seriesAsync({
		function(arg0_14)
			arg0_13.cg.alpha = 0

			arg0_13:UpdateList(arg0_14)
		end,
		function(arg0_15)
			onNextTick(arg0_15)
		end,
		function(arg0_16)
			arg0_13.cg.alpha = 1

			arg0_13:PlayAnimation(arg0_16)
		end
	}, function()
		arg0_13.cg.blocksRaycasts = true

		arg0_13:BlurPanel()
	end)
end

local function var8_0(arg0_18)
	setActive(arg0_18._tf, true)
	setButtonEnabled(arg0_18.closeBtn, true)
	arg0_18.pageAnim:Play("anim_storyrecordUI_record_in")

	arg0_18.state = var4_0

	arg0_18:UpdateAll()
end

function var0_0.Show(arg0_19, arg1_19)
	arg0_19.recorder = arg1_19
	arg0_19.displays = arg1_19:GetContentList()

	if arg0_19:IsEmptyOrUnload() then
		arg0_19:Load()
	elseif arg0_19:IsLoading() then
		-- block empty
	else
		var8_0(arg0_19)
	end
end

local function var9_0(arg0_20)
	local var0_20
	local var1_20 = false

	if #arg0_20.tplPools <= 0 then
		var0_20 = Object.Instantiate(arg0_20.tpl, arg0_20.tpl.parent)
	else
		var1_20 = true
		var0_20 = table.remove(arg0_20.tplPools, 1)
	end

	GetOrAddComponent(var0_20, typeof(CanvasGroup)).alpha = 1

	return var0_20, var1_20
end

local function var10_0(arg0_21, arg1_21)
	setActive(arg1_21, false)

	GetOrAddComponent(arg1_21, typeof(CanvasGroup)).alpha = 1

	if #arg0_21.tplPools >= 5 and arg1_21 ~= arg0_21.tpl then
		Object.Destroy(arg1_21.gameObject)
	else
		table.insert(arg0_21.tplPools, arg1_21)
	end
end

function var0_0.UpdateList(arg0_22, arg1_22)
	if not arg0_22:IsShowing() then
		return
	end

	local var0_22 = arg0_22.displays
	local var1_22 = {}
	local var2_22 = 1

	arg0_22.usingTpls = {}

	local var3_22 = #var0_22 < var7_0 and #var0_22 or var7_0

	for iter0_22, iter1_22 in ipairs(var0_22) do
		local var4_22 = #var0_22

		table.insert(var1_22, function(arg0_23)
			local var0_23, var1_23 = var9_0(arg0_22)

			if not var1_23 then
				var2_22 = var2_22 + 1
			end

			arg0_22:UpdateRecord(var0_23, iter1_22)
			table.insert(arg0_22.usingTpls, var0_23)
			tf(var0_23):SetAsLastSibling()

			if var2_22 % 5 == 0 then
				var2_22 = 1

				onNextTick(arg0_23)
			else
				arg0_23()
			end

			local var2_23 = var0_23:GetComponent(typeof(Animation))

			if iter0_22 + var3_22 <= var4_22 then
				setActive(var0_23, true)
				var2_23:Play("anim_storyrecordUI_tql_reset")
			else
				GetOrAddComponent(var0_23, typeof(CanvasGroup)).alpha = 0

				setActive(var0_23, true)
			end
		end)
	end

	table.insert(var1_22, function(arg0_24)
		onDelayTick(function()
			arg0_22.contentSizeFitter.enabled = false
			arg0_22.contentSizeFitter.enabled = true

			scrollToBottom(arg0_22._tf)
			arg0_24()
		end, 0.05)
	end)
	seriesAsync(var1_22, arg1_22)
end

function var0_0.PlayAnimation(arg0_26, arg1_26)
	local var0_26 = arg0_26.displays
	local var1_26 = #var0_26 < var7_0 and #var0_26 or var7_0
	local var2_26 = {}

	for iter0_26 = 1, var1_26 do
		table.insert(var2_26, function(arg0_27)
			local var0_27 = #arg0_26.usingTpls - var1_26 + iter0_26

			arg0_26.usingTpls[var0_27]:GetComponent(typeof(Animation)):Play("anim_storyrecordUI_tpl_in")
			onDelayTick(function()
				arg0_27()
			end, 0.033)
		end)
	end

	seriesAsync(var2_26)
	arg1_26()
end

function var0_0.UpdateRecord(arg0_29, arg1_29, arg2_29)
	GetOrAddComponent(arg1_29, typeof(CanvasGroup)).alpha = 1

	local var0_29 = arg1_29:Find("icon")

	setActive(var0_29, arg2_29.icon)

	if arg2_29.icon then
		local var1_29 = arg2_29.icon

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var1_29, "", var0_29:Find("Image"))
	end

	if arg2_29.name and arg2_29.nameColor then
		local var2_29 = string.gsub(arg2_29.nameColor, "#", "")

		arg1_29:Find("name"):GetComponent(typeof(Outline)).effectColor = Color.NewHex(var2_29)

		setText(arg1_29:Find("name"), setColorStr(arg2_29.name, arg2_29.nameColor))
	else
		setText(arg1_29:Find("name"), arg2_29.name or "")
	end

	local var3_29 = arg2_29.list
	local var4_29 = UIItemList.New(arg1_29:Find("content"), arg1_29:Find("content/Text"))

	var4_29:make(function(arg0_30, arg1_30, arg2_30)
		if arg0_30 == UIItemList.EventUpdate then
			setText(arg2_30, var3_29[arg1_30 + 1])
		end
	end)
	var4_29:align(#var3_29)
	setActive(arg1_29:Find("player"), arg2_29.icon == nil and arg2_29.isPlayer)

	local var5_29 = arg2_29.icon == nil and arg2_29.name == nil
	local var6_29 = var4_29.container:GetComponent(typeof(UnityEngine.UI.HorizontalOrVerticalLayoutGroup))
	local var7_29 = UnityEngine.RectOffset.New()

	var7_29.left = 170
	var7_29.right = 0
	var7_29.top = var5_29 and 25 or 90
	var7_29.bottom = var5_29 and 25 or 50
	var6_29.padding = var7_29
end

function var0_0.OnHide(arg0_31)
	arg0_31:Clear()
	arg0_31:UnblurPanel()
	setActive(arg0_31._tf, false)
	setButtonEnabled(arg0_31.closeBtn, true)

	arg0_31.state = var5_0
end

function var0_0.Hide(arg0_32)
	if arg0_32:IsShowing() then
		arg0_32.pageAnim:Play("anim_storyrecordUI_record_out")
	end
end

function var0_0.BlurPanel(arg0_33)
	setParent(pg.NewStoryMgr.GetInstance()._tf, pg.UIMgr.GetInstance().UIMain)

	local var0_33 = pg.UIMgr.GetInstance().OverlayMain

	arg0_33.hideNodes = {}

	for iter0_33 = 1, var0_33.childCount do
		local var1_33 = var0_33:GetChild(iter0_33 - 1)

		if isActive(var1_33) then
			table.insert(arg0_33.hideNodes, var1_33)
			setActive(var1_33, false)
		end
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_33._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0_0.UnblurPanel(arg0_34)
	setParent(pg.NewStoryMgr.GetInstance()._tf, pg.UIMgr.GetInstance().OverlayToast)

	if arg0_34.hideNodes and #arg0_34.hideNodes > 0 then
		for iter0_34, iter1_34 in ipairs(arg0_34.hideNodes) do
			setActive(iter1_34, true)
		end
	end

	arg0_34.hideNodes = {}

	pg.UIMgr.GetInstance():UnblurPanel(arg0_34._tf, arg0_34.parentTF)
end

function var0_0.Clear(arg0_35)
	for iter0_35, iter1_35 in ipairs(arg0_35.usingTpls) do
		var10_0(arg0_35, iter1_35)
	end

	arg0_35.usingTpls = {}
end

function var0_0.Unload(arg0_36)
	if arg0_36.state > var2_0 then
		arg0_36.state = var6_0

		if not IsNil(arg0_36.closeBtn) then
			removeOnButton(arg0_36.closeBtn)
		end

		Object.Destroy(arg0_36._go)

		arg0_36._go = nil
		arg0_36._tf = nil
		arg0_36.container = nil
		arg0_36.tpl = nil
	end
end

function var0_0.Dispose(arg0_37)
	arg0_37:Hide()
	arg0_37:Unload()
end

return var0_0
