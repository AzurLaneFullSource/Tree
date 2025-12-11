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
	arg0_10.closeBtn = arg0_10._tf:Find("adapt/close")
	arg0_10.bgImage = arg0_10._tf:GetComponent(typeof(Image))
	arg0_10.scrollrect = arg0_10._tf:GetComponent(typeof(ScrollRect))
	arg0_10.contentSizeFitter = arg0_10._tf:Find("content"):GetComponent(typeof(ContentSizeFitter))

	onButton(nil, arg0_10.closeBtn, function()
		setButtonEnabled(arg0_10.closeBtn, false)
		arg0_10:Hide()
	end, SFX_PANEL)

	arg0_10.state = var4_0

	arg0_10:UpdateAll()
end

function var0_0.UpdateAll(arg0_12)
	arg0_12.cg.blocksRaycasts = false

	seriesAsync({
		function(arg0_13)
			arg0_12.cg.alpha = 0

			arg0_12:UpdateList(arg0_13)
		end,
		function(arg0_14)
			onNextTick(arg0_14)
		end,
		function(arg0_15)
			arg0_12.cg.alpha = 1

			arg0_12:PlayAnimation(arg0_15)
		end
	}, function()
		arg0_12.cg.blocksRaycasts = true

		arg0_12:BlurPanel()
	end)
end

local function var8_0(arg0_17)
	setActive(arg0_17._tf, true)
	setButtonEnabled(arg0_17.closeBtn, true)
	arg0_17.pageAniEvent:SetEndEvent(function()
		arg0_17.pageAniEvent:SetEndEvent(nil)
	end)
	arg0_17.pageAnim:Play("anim_storyrecordUI_record_in")

	arg0_17.state = var4_0

	arg0_17:UpdateAll()
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

function var0_0.UpdateIcon(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg1_29.icon

	GetImageSpriteFromAtlasAsync("SquareIcon/" .. var0_29, "", arg2_29:Find("Image"))
end

function var0_0.UpdateRecord(arg0_30, arg1_30, arg2_30)
	GetOrAddComponent(arg1_30, typeof(CanvasGroup)).alpha = 1

	local var0_30 = arg1_30:Find("icon")

	setActive(var0_30, arg2_30.icon)

	if arg2_30.icon then
		arg0_30:UpdateIcon(arg2_30, var0_30)
	end

	if arg2_30.name and arg2_30.nameColor then
		local var1_30 = string.gsub(arg2_30.nameColor, "#", "")

		arg1_30:Find("name"):GetComponent(typeof(Outline)).effectColor = Color.NewHex(var1_30)

		setText(arg1_30:Find("name"), setColorStr(arg2_30.name, arg2_30.nameColor))
	else
		setText(arg1_30:Find("name"), arg2_30.name or "")
	end

	local var2_30 = arg2_30.list
	local var3_30 = UIItemList.New(arg1_30:Find("content"), arg1_30:Find("content/Text"))

	var3_30:make(function(arg0_31, arg1_31, arg2_31)
		if arg0_31 == UIItemList.EventUpdate then
			setText(arg2_31, var2_30[arg1_31 + 1])
		end
	end)
	var3_30:align(#var2_30)
	setActive(arg1_30:Find("player"), arg2_30.icon == nil and arg2_30.isPlayer)

	local var4_30 = arg2_30.icon == nil and arg2_30.name == nil
	local var5_30 = var3_30.container:GetComponent(typeof(UnityEngine.UI.HorizontalOrVerticalLayoutGroup))
	local var6_30 = UnityEngine.RectOffset.New()

	var6_30.left = 170
	var6_30.right = 0
	var6_30.top = var4_30 and 25 or 90
	var6_30.bottom = var4_30 and 25 or 50
	var5_30.padding = var6_30
end

function var0_0.OnHide(arg0_32)
	arg0_32:Clear()
	arg0_32:UnblurPanel()
	setActive(arg0_32._tf, false)
	setButtonEnabled(arg0_32.closeBtn, true)

	arg0_32.state = var5_0
end

function var0_0.Hide(arg0_33)
	if arg0_33:IsShowing() then
		arg0_33.pageAniEvent:SetEndEvent(nil)
		arg0_33.pageAniEvent:SetEndEvent(function()
			arg0_33:OnHide()
		end)
		arg0_33.pageAnim:Play("anim_storyrecordUI_record_out")
	end
end

function var0_0.BlurPanel(arg0_35)
	setParent(pg.NewStoryMgr.GetInstance()._tf, pg.UIMgr.GetInstance().UIMain)

	local var0_35 = pg.UIMgr.GetInstance().OverlayMain

	arg0_35.hideNodes = {}

	for iter0_35 = 1, var0_35.childCount do
		local var1_35 = var0_35:GetChild(iter0_35 - 1)

		if isActive(var1_35) then
			table.insert(arg0_35.hideNodes, var1_35)
			setActive(var1_35, false)
		end
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_35._tf)
end

function var0_0.UnblurPanel(arg0_36)
	setParent(pg.NewStoryMgr.GetInstance()._tf, pg.UIMgr.GetInstance().OverlayToast)

	if arg0_36.hideNodes and #arg0_36.hideNodes > 0 then
		for iter0_36, iter1_36 in ipairs(arg0_36.hideNodes) do
			setActive(iter1_36, true)
		end
	end

	arg0_36.hideNodes = {}

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_36._tf, arg0_36.parentTF)
end

function var0_0.Clear(arg0_37)
	for iter0_37, iter1_37 in ipairs(arg0_37.usingTpls) do
		var10_0(arg0_37, iter1_37)
	end

	arg0_37.usingTpls = {}
end

function var0_0.Unload(arg0_38)
	if arg0_38.state > var2_0 then
		arg0_38.state = var6_0

		if not IsNil(arg0_38.closeBtn) then
			removeOnButton(arg0_38.closeBtn)
		end

		Object.Destroy(arg0_38._go)

		arg0_38._go = nil
		arg0_38._tf = nil
		arg0_38.container = nil
		arg0_38.tpl = nil
	end
end

function var0_0.Dispose(arg0_39)
	arg0_39:Hide()
	arg0_39:Unload()
end

return var0_0
