local var0_0 = class("NewStoryRecordPanel")
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2
local var4_0 = 3
local var5_0 = 4
local var6_0 = 5
local var7_0 = 10

function var0_0.Ctor(arg0_1)
	arg0_1.state = var1_0
end

function var0_0.Load(arg0_2)
	arg0_2.state = var2_0
	arg0_2.parentTF = pg.NewStoryMgr.GetInstance().frontTr

	ResourceMgr.Inst:getAssetAsync("ui/NewStoryRecordUI", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_3)
		local var0_3 = Object.Instantiate(arg0_3, arg0_2.parentTF)

		if arg0_2:IsLoading() then
			arg0_2.state = var3_0

			arg0_2:Init(var0_3)
		end
	end), true, true)
end

function var0_0.IsEmptyOrUnload(arg0_4)
	return arg0_4.state == var1_0 or arg0_4.state == var6_0
end

function var0_0.IsLoading(arg0_5)
	return arg0_5.state == var2_0
end

function var0_0.IsShowing(arg0_6)
	return arg0_6.state == var4_0
end

function var0_0.CanOpen(arg0_7)
	return arg0_7.state == var1_0 or arg0_7.state == var5_0 or arg0_7.state == var6_0
end

function var0_0.Init(arg0_8, arg1_8)
	arg0_8._go = arg1_8
	arg0_8._tf = arg1_8.transform
	arg0_8.pageAnim = arg0_8._tf:GetComponent(typeof(Animation))
	arg0_8.pageAniEvent = arg0_8._tf:GetComponent(typeof(DftAniEvent))
	arg0_8.container = arg0_8._tf:Find("content")
	arg0_8.tpl = arg0_8._tf:Find("content/tpl")
	arg0_8.cg = GetOrAddComponent(arg0_8._tf, typeof(CanvasGroup))
	arg0_8.tplPools = {
		arg0_8.tpl
	}
	arg0_8.closeBtn = arg0_8._tf:Find("close")
	arg0_8.scrollrect = arg0_8._tf:GetComponent(typeof(ScrollRect))
	arg0_8.contentSizeFitter = arg0_8._tf:Find("content"):GetComponent(typeof(ContentSizeFitter))

	onButton(nil, arg0_8.closeBtn, function()
		setButtonEnabled(arg0_8.closeBtn, false)
		arg0_8:Hide()
	end, SFX_PANEL)
	arg0_8.pageAniEvent:SetEndEvent(function()
		arg0_8:OnHide()
	end)

	arg0_8.state = var4_0

	arg0_8:UpdateAll()
end

function var0_0.UpdateAll(arg0_11)
	arg0_11.cg.blocksRaycasts = false

	seriesAsync({
		function(arg0_12)
			arg0_11.cg.alpha = 0

			arg0_11:UpdateList(arg0_12)
		end,
		function(arg0_13)
			onNextTick(arg0_13)
		end,
		function(arg0_14)
			arg0_11.cg.alpha = 1

			arg0_11:PlayAnimation(arg0_14)
		end
	}, function()
		arg0_11.cg.blocksRaycasts = true

		arg0_11:BlurPanel()
	end)
end

local function var8_0(arg0_16)
	setActive(arg0_16._tf, true)
	setButtonEnabled(arg0_16.closeBtn, true)
	arg0_16.pageAnim:Play("anim_storyrecordUI_record_in")

	arg0_16.state = var4_0

	arg0_16:UpdateAll()
end

function var0_0.Show(arg0_17, arg1_17)
	arg0_17.displays = arg1_17:GetContentList()

	if arg0_17:IsEmptyOrUnload() then
		arg0_17:Load()
	elseif arg0_17:IsLoading() then
		-- block empty
	else
		var8_0(arg0_17)
	end
end

local function var9_0(arg0_18)
	local var0_18
	local var1_18 = false

	if #arg0_18.tplPools <= 0 then
		var0_18 = Object.Instantiate(arg0_18.tpl, arg0_18.tpl.parent)
	else
		var1_18 = true
		var0_18 = table.remove(arg0_18.tplPools, 1)
	end

	GetOrAddComponent(var0_18, typeof(CanvasGroup)).alpha = 1

	return var0_18, var1_18
end

local function var10_0(arg0_19, arg1_19)
	setActive(arg1_19, false)

	GetOrAddComponent(arg1_19, typeof(CanvasGroup)).alpha = 1

	if #arg0_19.tplPools >= 5 and arg1_19 ~= arg0_19.tpl then
		Object.Destroy(arg1_19.gameObject)
	else
		table.insert(arg0_19.tplPools, arg1_19)
	end
end

function var0_0.UpdateList(arg0_20, arg1_20)
	if not arg0_20:IsShowing() then
		return
	end

	local var0_20 = arg0_20.displays
	local var1_20 = {}
	local var2_20 = 1

	arg0_20.usingTpls = {}

	local var3_20 = #var0_20 < var7_0 and #var0_20 or var7_0

	for iter0_20, iter1_20 in ipairs(var0_20) do
		local var4_20 = #var0_20

		table.insert(var1_20, function(arg0_21)
			local var0_21, var1_21 = var9_0(arg0_20)

			if not var1_21 then
				var2_20 = var2_20 + 1
			end

			arg0_20:UpdateRecord(var0_21, iter1_20)
			table.insert(arg0_20.usingTpls, var0_21)
			tf(var0_21):SetAsLastSibling()

			if var2_20 % 5 == 0 then
				var2_20 = 1

				onNextTick(arg0_21)
			else
				arg0_21()
			end

			local var2_21 = var0_21:GetComponent(typeof(Animation))

			if iter0_20 + var3_20 <= var4_20 then
				setActive(var0_21, true)
				var2_21:Play("anim_storyrecordUI_tql_reset")
			else
				GetOrAddComponent(var0_21, typeof(CanvasGroup)).alpha = 0

				setActive(var0_21, true)
			end
		end)
	end

	table.insert(var1_20, function(arg0_22)
		onDelayTick(function()
			arg0_20.contentSizeFitter.enabled = false
			arg0_20.contentSizeFitter.enabled = true

			scrollToBottom(arg0_20._tf)
			arg0_22()
		end, 0.05)
	end)
	seriesAsync(var1_20, arg1_20)
end

function var0_0.PlayAnimation(arg0_24, arg1_24)
	local var0_24 = arg0_24.displays
	local var1_24 = #var0_24 < var7_0 and #var0_24 or var7_0
	local var2_24 = {}

	for iter0_24 = 1, var1_24 do
		table.insert(var2_24, function(arg0_25)
			local var0_25 = #arg0_24.usingTpls - var1_24 + iter0_24

			arg0_24.usingTpls[var0_25]:GetComponent(typeof(Animation)):Play("anim_storyrecordUI_tpl_in")
			onDelayTick(function()
				arg0_25()
			end, 0.033)
		end)
	end

	seriesAsync(var2_24)
	arg1_24()
end

function var0_0.UpdateRecord(arg0_27, arg1_27, arg2_27)
	GetOrAddComponent(arg1_27, typeof(CanvasGroup)).alpha = 1

	setActive(arg1_27:Find("icon"), arg2_27.icon)

	if arg2_27.icon then
		local var0_27 = arg2_27.icon

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var0_27, "", arg1_27:Find("icon/Image"))
	end

	if arg2_27.name and arg2_27.nameColor then
		local var1_27 = string.gsub(arg2_27.nameColor, "#", "")

		arg1_27:Find("name"):GetComponent(typeof(Outline)).effectColor = Color.NewHex(var1_27)

		setText(arg1_27:Find("name"), setColorStr(arg2_27.name, arg2_27.nameColor))
	else
		setText(arg1_27:Find("name"), arg2_27.name or "")
	end

	local var2_27 = arg2_27.list
	local var3_27 = UIItemList.New(arg1_27:Find("content"), arg1_27:Find("content/Text"))

	var3_27:make(function(arg0_28, arg1_28, arg2_28)
		if arg0_28 == UIItemList.EventUpdate then
			setText(arg2_28, var2_27[arg1_28 + 1])
		end
	end)
	var3_27:align(#var2_27)
	setActive(arg1_27:Find("player"), arg2_27.icon == nil and arg2_27.isPlayer)

	local var4_27 = arg2_27.icon == nil and arg2_27.name == nil
	local var5_27 = var3_27.container:GetComponent(typeof(UnityEngine.UI.HorizontalOrVerticalLayoutGroup))
	local var6_27 = UnityEngine.RectOffset.New()

	var6_27.left = 170
	var6_27.right = 0
	var6_27.top = var4_27 and 25 or 90
	var6_27.bottom = var4_27 and 25 or 50
	var5_27.padding = var6_27
end

function var0_0.OnHide(arg0_29)
	arg0_29:Clear()
	arg0_29:UnblurPanel()
	setActive(arg0_29._tf, false)
	setButtonEnabled(arg0_29.closeBtn, true)

	arg0_29.state = var5_0
end

function var0_0.Hide(arg0_30)
	if arg0_30:IsShowing() then
		arg0_30.pageAnim:Play("anim_storyrecordUI_record_out")
	end
end

function var0_0.BlurPanel(arg0_31)
	setParent(pg.NewStoryMgr.GetInstance()._tf, pg.UIMgr.GetInstance().UIMain)

	local var0_31 = pg.UIMgr.GetInstance().OverlayMain

	arg0_31.hideNodes = {}

	for iter0_31 = 1, var0_31.childCount do
		local var1_31 = var0_31:GetChild(iter0_31 - 1)

		if isActive(var1_31) then
			table.insert(arg0_31.hideNodes, var1_31)
			setActive(var1_31, false)
		end
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_31._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0_0.UnblurPanel(arg0_32)
	setParent(pg.NewStoryMgr.GetInstance()._tf, pg.UIMgr.GetInstance().OverlayToast)

	if arg0_32.hideNodes and #arg0_32.hideNodes > 0 then
		for iter0_32, iter1_32 in ipairs(arg0_32.hideNodes) do
			setActive(iter1_32, true)
		end
	end

	arg0_32.hideNodes = {}

	pg.UIMgr.GetInstance():UnblurPanel(arg0_32._tf, arg0_32.parentTF)
end

function var0_0.Clear(arg0_33)
	for iter0_33, iter1_33 in ipairs(arg0_33.usingTpls) do
		var10_0(arg0_33, iter1_33)
	end

	arg0_33.usingTpls = {}
end

function var0_0.Unload(arg0_34)
	if arg0_34.state > var2_0 then
		arg0_34.state = var6_0

		if not IsNil(arg0_34.closeBtn) then
			removeOnButton(arg0_34.closeBtn)
		end

		Object.Destroy(arg0_34._go)

		arg0_34._go = nil
		arg0_34._tf = nil
		arg0_34.container = nil
		arg0_34.tpl = nil
	end
end

function var0_0.Dispose(arg0_35)
	arg0_35:Hide()
	arg0_35:Unload()
end

return var0_0
