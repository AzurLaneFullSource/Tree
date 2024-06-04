local var0 = class("NewStoryRecordPanel")
local var1 = 0
local var2 = 1
local var3 = 2
local var4 = 3
local var5 = 4
local var6 = 5
local var7 = 10

function var0.Ctor(arg0)
	arg0.state = var1
end

function var0.Load(arg0)
	arg0.state = var2
	arg0.parentTF = pg.NewStoryMgr.GetInstance().frontTr

	ResourceMgr.Inst:getAssetAsync("ui/NewStoryRecordUI", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		local var0 = Object.Instantiate(arg0, arg0.parentTF)

		if arg0:IsLoading() then
			arg0.state = var3

			arg0:Init(var0)
		end
	end), true, true)
end

function var0.IsEmptyOrUnload(arg0)
	return arg0.state == var1 or arg0.state == var6
end

function var0.IsLoading(arg0)
	return arg0.state == var2
end

function var0.IsShowing(arg0)
	return arg0.state == var4
end

function var0.CanOpen(arg0)
	return arg0.state == var1 or arg0.state == var5 or arg0.state == var6
end

function var0.Init(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.pageAnim = arg0._tf:GetComponent(typeof(Animation))
	arg0.pageAniEvent = arg0._tf:GetComponent(typeof(DftAniEvent))
	arg0.container = arg0._tf:Find("content")
	arg0.tpl = arg0._tf:Find("content/tpl")
	arg0.cg = GetOrAddComponent(arg0._tf, typeof(CanvasGroup))
	arg0.tplPools = {
		arg0.tpl
	}
	arg0.closeBtn = arg0._tf:Find("close")
	arg0.scrollrect = arg0._tf:GetComponent(typeof(ScrollRect))
	arg0.contentSizeFitter = arg0._tf:Find("content"):GetComponent(typeof(ContentSizeFitter))

	onButton(nil, arg0.closeBtn, function()
		setButtonEnabled(arg0.closeBtn, false)
		arg0:Hide()
	end, SFX_PANEL)
	arg0.pageAniEvent:SetEndEvent(function()
		arg0:OnHide()
	end)

	arg0.state = var4

	arg0:UpdateAll()
end

function var0.UpdateAll(arg0)
	arg0.cg.blocksRaycasts = false

	seriesAsync({
		function(arg0)
			arg0.cg.alpha = 0

			arg0:UpdateList(arg0)
		end,
		function(arg0)
			onNextTick(arg0)
		end,
		function(arg0)
			arg0.cg.alpha = 1

			arg0:PlayAnimation(arg0)
		end
	}, function()
		arg0.cg.blocksRaycasts = true

		arg0:BlurPanel()
	end)
end

local function var8(arg0)
	setActive(arg0._tf, true)
	setButtonEnabled(arg0.closeBtn, true)
	arg0.pageAnim:Play("anim_storyrecordUI_record_in")

	arg0.state = var4

	arg0:UpdateAll()
end

function var0.Show(arg0, arg1)
	arg0.displays = arg1:GetContentList()

	if arg0:IsEmptyOrUnload() then
		arg0:Load()
	elseif arg0:IsLoading() then
		-- block empty
	else
		var8(arg0)
	end
end

local function var9(arg0)
	local var0
	local var1 = false

	if #arg0.tplPools <= 0 then
		var0 = Object.Instantiate(arg0.tpl, arg0.tpl.parent)
	else
		var1 = true
		var0 = table.remove(arg0.tplPools, 1)
	end

	GetOrAddComponent(var0, typeof(CanvasGroup)).alpha = 1

	return var0, var1
end

local function var10(arg0, arg1)
	setActive(arg1, false)

	GetOrAddComponent(arg1, typeof(CanvasGroup)).alpha = 1

	if #arg0.tplPools >= 5 and arg1 ~= arg0.tpl then
		Object.Destroy(arg1.gameObject)
	else
		table.insert(arg0.tplPools, arg1)
	end
end

function var0.UpdateList(arg0, arg1)
	if not arg0:IsShowing() then
		return
	end

	local var0 = arg0.displays
	local var1 = {}
	local var2 = 1

	arg0.usingTpls = {}

	local var3 = #var0 < var7 and #var0 or var7

	for iter0, iter1 in ipairs(var0) do
		local var4 = #var0

		table.insert(var1, function(arg0)
			local var0, var1 = var9(arg0)

			if not var1 then
				var2 = var2 + 1
			end

			arg0:UpdateRecord(var0, iter1)
			table.insert(arg0.usingTpls, var0)
			tf(var0):SetAsLastSibling()

			if var2 % 5 == 0 then
				var2 = 1

				onNextTick(arg0)
			else
				arg0()
			end

			local var2 = var0:GetComponent(typeof(Animation))

			if iter0 + var3 <= var4 then
				setActive(var0, true)
				var2:Play("anim_storyrecordUI_tql_reset")
			else
				GetOrAddComponent(var0, typeof(CanvasGroup)).alpha = 0

				setActive(var0, true)
			end
		end)
	end

	table.insert(var1, function(arg0)
		onDelayTick(function()
			arg0.contentSizeFitter.enabled = false
			arg0.contentSizeFitter.enabled = true

			scrollToBottom(arg0._tf)
			arg0()
		end, 0.05)
	end)
	seriesAsync(var1, arg1)
end

function var0.PlayAnimation(arg0, arg1)
	local var0 = arg0.displays
	local var1 = #var0 < var7 and #var0 or var7
	local var2 = {}

	for iter0 = 1, var1 do
		table.insert(var2, function(arg0)
			local var0 = #arg0.usingTpls - var1 + iter0

			arg0.usingTpls[var0]:GetComponent(typeof(Animation)):Play("anim_storyrecordUI_tpl_in")
			onDelayTick(function()
				arg0()
			end, 0.033)
		end)
	end

	seriesAsync(var2)
	arg1()
end

function var0.UpdateRecord(arg0, arg1, arg2)
	GetOrAddComponent(arg1, typeof(CanvasGroup)).alpha = 1

	setActive(arg1:Find("icon"), arg2.icon)

	if arg2.icon then
		local var0 = arg2.icon

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var0, "", arg1:Find("icon/Image"))
	end

	if arg2.name and arg2.nameColor then
		local var1 = string.gsub(arg2.nameColor, "#", "")

		arg1:Find("name"):GetComponent(typeof(Outline)).effectColor = Color.NewHex(var1)

		setText(arg1:Find("name"), setColorStr(arg2.name, arg2.nameColor))
	else
		setText(arg1:Find("name"), arg2.name or "")
	end

	local var2 = arg2.list
	local var3 = UIItemList.New(arg1:Find("content"), arg1:Find("content/Text"))

	var3:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			setText(arg2, var2[arg1 + 1])
		end
	end)
	var3:align(#var2)
	setActive(arg1:Find("player"), arg2.icon == nil and arg2.isPlayer)

	local var4 = arg2.icon == nil and arg2.name == nil
	local var5 = var3.container:GetComponent(typeof(UnityEngine.UI.HorizontalOrVerticalLayoutGroup))
	local var6 = UnityEngine.RectOffset.New()

	var6.left = 170
	var6.right = 0
	var6.top = var4 and 25 or 90
	var6.bottom = var4 and 25 or 50
	var5.padding = var6
end

function var0.OnHide(arg0)
	arg0:Clear()
	arg0:UnblurPanel()
	setActive(arg0._tf, false)
	setButtonEnabled(arg0.closeBtn, true)

	arg0.state = var5
end

function var0.Hide(arg0)
	if arg0:IsShowing() then
		arg0.pageAnim:Play("anim_storyrecordUI_record_out")
	end
end

function var0.BlurPanel(arg0)
	setParent(pg.NewStoryMgr.GetInstance()._tf, pg.UIMgr.GetInstance().UIMain)

	local var0 = pg.UIMgr.GetInstance().OverlayMain

	arg0.hideNodes = {}

	for iter0 = 1, var0.childCount do
		local var1 = var0:GetChild(iter0 - 1)

		if isActive(var1) then
			table.insert(arg0.hideNodes, var1)
			setActive(var1, false)
		end
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0.UnblurPanel(arg0)
	setParent(pg.NewStoryMgr.GetInstance()._tf, pg.UIMgr.GetInstance().OverlayToast)

	if arg0.hideNodes and #arg0.hideNodes > 0 then
		for iter0, iter1 in ipairs(arg0.hideNodes) do
			setActive(iter1, true)
		end
	end

	arg0.hideNodes = {}

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0.parentTF)
end

function var0.Clear(arg0)
	for iter0, iter1 in ipairs(arg0.usingTpls) do
		var10(arg0, iter1)
	end

	arg0.usingTpls = {}
end

function var0.Unload(arg0)
	if arg0.state > var2 then
		arg0.state = var6

		if not IsNil(arg0.closeBtn) then
			removeOnButton(arg0.closeBtn)
		end

		Object.Destroy(arg0._go)

		arg0._go = nil
		arg0._tf = nil
		arg0.container = nil
		arg0.tpl = nil
	end
end

function var0.Dispose(arg0)
	arg0:Hide()
	arg0:Unload()
end

return var0
