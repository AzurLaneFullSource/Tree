local var0_0 = class("IslandShipDressUpPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShipDressUI"
end

var0_0.Skin = 1
var0_0.Wing = 2
var0_0.FollowingObj = 3
var0_0.Trailing = 4
var0_0.Footprint = 5

local var1_0 = {
	Down_up = 1,
	Up_Down = 2
}

function var0_0.OnLoaded(arg0_2)
	arg0_2.rightPanel = arg0_2:findTF("adapt/right_panel")
	arg0_2.togglePanel = arg0_2.rightPanel:Find("toggles")
	arg0_2.saveBtn = arg0_2:findTF("adapt/save")
	arg0_2.toggles = {
		[var0_0.Skin] = arg0_2.togglePanel:Find("skin"),
		[var0_0.Wing] = arg0_2.togglePanel:Find("wing"),
		[var0_0.FollowingObj] = arg0_2.togglePanel:Find("followingObj"),
		[var0_0.Trailing] = arg0_2.togglePanel:Find("trailing"),
		[var0_0.Footprint] = arg0_2.togglePanel:Find("footprint")
	}
	arg0_2.charContainer = arg0_2:findTF("adapt/char")
	arg0_2.dressCards = {}
	arg0_2.dressRect = arg0_2:findTF("adapt/right_panel/dress_container/dress"):GetComponent("LScrollRect")
	arg0_2.dressList = {}

	function arg0_2.dressRect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.dressRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end
end

function var0_0.ClickDressCardItem(arg0_5, arg1_5)
	local var0_5 = arg0_5.pageDressDic[arg0_5.currentDressPageType]
	local var1_5 = var0_5 and var0_5.currentItemId or nil

	if var1_5 == arg1_5 then
		arg0_5:ClearSelected(arg1_5)

		if var0_5.currentItemObj then
			setActive(var0_5.currentItemObj, false)

			var0_5.currentItemObj = nil
		end

		var0_5.currentItemId = nil

		return
	end

	if var1_5 ~= nil then
		if var0_5.currentItemObj then
			setActive(var0_5.currentItemObj, false)

			var0_5.currentItemObj = nil
		end

		var0_5.currentItemId = nil
	end

	arg0_5:LoadDressupPrefab(arg1_5, arg0_5.currentDressPageType)

	local var2_5 = arg0_5.pageDressDic[arg0_5.currentDressPageType] or {}

	var2_5.currentItemId = arg1_5
	arg0_5.pageDressDic[arg0_5.currentDressPageType] = var2_5

	arg0_5:ClearSelected(var1_5)
	arg0_5:MarkSelected(var2_5.currentItemId)
end

function var0_0.CheckIsInDress(arg0_6, arg1_6)
	for iter0_6, iter1_6 in pairs(arg0_6.pageDressDic) do
		if iter1_6.currentItemId == arg1_6 then
			return true
		end
	end

	return false
end

function var0_0.LoadDressupPrefab(arg0_7, arg1_7, arg2_7)
	local function var0_7(arg0_8)
		local var0_8 = arg0_7.pageDressDic[arg2_7] or {}

		var0_8.currentItemObj = arg0_8
		arg0_7.pageDressDic[arg2_7] = var0_8
	end

	local var1_7 = arg0_7.dressObjectPool[arg1_7]

	if var1_7 then
		setActive(var1_7, true)
		var0_7(var1_7)

		return
	end

	local var2_7 = pg.island_dress_template[arg1_7]
	local var3_7 = var2_7.model

	ResourceMgr.Inst:getAssetAsync(var3_7, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_9)
		if not arg0_7:CheckIsInDress(arg1_7) then
			return
		end

		local var0_9 = Object.Instantiate(arg0_9)

		pg.ViewUtils.SetLayer(var0_9.transform, Layer.UI)

		local var1_9 = arg0_7.role.transform

		if var2_7.attachmentPoint ~= "" then
			local var2_9 = var2_7.attachmentPoint

			local function var3_9(arg0_10)
				for iter0_10 = 0, arg0_10.childCount - 1 do
					local var0_10 = arg0_10:GetChild(iter0_10)

					if var0_10.name == var2_9 then
						return var0_10
					end

					local var1_10 = var3_9(var0_10, var2_9)

					if var1_10 then
						return var1_10
					end
				end

				return nil
			end

			var1_9 = var3_9(var1_9)
		end

		if var2_7.offset ~= "" then
			local var4_9 = Vector3(var2_7.offset[1], var2_7.offset[2], var2_7.offset[3])

			var0_9.transform.position = var4_9
		end

		setParent(var0_9, var1_9)
		var0_7(var0_9)

		arg0_7.dressObjectPool[arg1_7] = var0_9
	end), true, true)
end

function var0_0.MarkSelected(arg0_11, arg1_11)
	for iter0_11, iter1_11 in pairs(arg0_11.dressCards) do
		if iter1_11.configId == arg1_11 and iter1_11.configType == arg0_11.currentDressPageType then
			iter1_11:UpdateSelected(iter1_11.configId)

			break
		end
	end
end

function var0_0.OnInitItem(arg0_12, arg1_12)
	local var0_12 = tf(arg1_12)
	local var1_12 = IslandDressCard.New(arg1_12)

	arg0_12.dressCards[arg1_12] = var1_12
end

function var0_0.ClearSelected(arg0_13, arg1_13)
	for iter0_13, iter1_13 in pairs(arg0_13.dressCards) do
		if iter1_13.configId == arg1_13 and iter1_13.configType == arg0_13.currentDressPageType then
			iter1_13:UpdateSelected(nil)

			break
		end
	end
end

function var0_0.OnUpdateItem(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.dressCards[arg2_14]

	if not var0_14 then
		arg0_14:OnInitItem(arg2_14)

		var0_14 = arg0_14.dressCards[arg2_14]
	end

	local var1_14 = arg0_14.dressList[arg1_14 + 1]
	local var2_14 = tf(arg2_14)

	onButton(arg0_14, var2_14, function()
		arg0_14:ClickDressCardItem(var1_14)
	end)

	local var3_14 = arg0_14.pageDressDic[arg0_14.currentDressPageType] and arg0_14.pageDressDic[arg0_14.currentDressPageType].currentItemId or nil

	var0_14:Update(var1_14, var3_14)
end

function var0_0.AddListeners(arg0_16)
	return
end

function var0_0.RemoveListeners(arg0_17)
	return
end

function var0_0.OnClosePage(arg0_18, arg1_18)
	return
end

function var0_0.LoadCharacter(arg0_19, arg1_19, arg2_19)
	ResourceMgr.Inst:getAssetAsync(arg1_19, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_20)
		arg0_19.role = Object.Instantiate(arg0_20)

		setParent(arg0_19.role, arg0_19.charContainer)
		GetOrAddComponent(arg0_19.charContainer, typeof(SmoothRotateChildObject))
		arg2_19(arg0_19.role)
	end), true, true)
end

function var0_0.UnloadCharacter(arg0_21)
	local var0_21 = arg0_21.charContainer:GetComponent(typeof(SmoothRotateChildObject))

	if var0_21 then
		Object.Destroy(var0_21)
	end

	if arg0_21.role then
		Object.Destroy(arg0_21.role)

		arg0_21.role = nil
		arg0_21.prefab = nil
	end
end

function var0_0.OnInit(arg0_22)
	onButton(arg0_22, arg0_22.saveBtn, function()
		arg0_22:SaveDressUpData()
	end, SFX_PANEL)

	for iter0_22, iter1_22 in ipairs(arg0_22.toggles) do
		onToggle(arg0_22, iter1_22, function(arg0_24)
			if arg0_24 then
				arg0_22:SwitchPage(iter0_22)
			end
		end, SFX_PANEL)
	end
end

function var0_0.SwitchPage(arg0_25, arg1_25)
	arg0_25.currentDressPageType = arg1_25
	arg0_25.dressList = pg.island_dress_template.get_id_list_by_type[arg0_25.currentDressPageType] or {}

	if not arg0_25.hasInit then
		arg0_25.hasInit = true

		onNextTick(function()
			arg0_25:SortDressListByQuality()
		end)
	else
		arg0_25:SortDressListByQuality()
	end
end

function var0_0.SortDressListByQuality(arg0_27)
	table.sort(arg0_27.dressList, function(arg0_28, arg1_28)
		local var0_28 = pg.island_dress_template[arg0_28]
		local var1_28 = pg.island_dress_template[arg1_28]

		local function var2_28()
			if arg0_27.dressSortType == var1_0.Down_up then
				return var0_28.quality < var1_28.quality
			else
				return var0_28.quality > var1_28.quality
			end
		end

		if var0_28.quality ~= var1_28.quality then
			return var2_28()
		end

		return var0_28.id < var1_28.id
	end)

	local var0_27 = #arg0_27.dressList

	arg0_27.dressRect:SetTotalCount(var0_27, 0)
end

function var0_0.InitCharacter(arg0_30)
	local var0_30 = pg.island_ship[0].model

	arg0_30:LoadCharacter(var0_30, function(arg0_31)
		arg0_31.transform.localRotation = Vector3(0, 180, 0)
		arg0_31.transform.localScale = Vector3(400, 400, 400)
		arg0_31.transform.localPosition = Vector3(0, 0, -600)

		pg.ViewUtils.SetLayer(arg0_31.transform, Layer.UI)

		for iter0_31, iter1_31 in pairs(arg0_30.initDressData) do
			arg0_30:LoadDressupPrefab(iter1_31, iter0_31)
		end
	end)

	for iter0_30, iter1_30 in pairs(arg0_30.initDressData) do
		local var1_30 = arg0_30.pageDressDic[iter0_30] or {}

		var1_30.currentItemId = iter1_30
		arg0_30.pageDressDic[iter0_30] = var1_30
	end
end

function var0_0.Flush(arg0_32)
	return
end

function var0_0.OnShow(arg0_33)
	local var0_33 = arg0_33.rightPanel:Find("filtrate/filtrate_sort/tag_down")
	local var1_33 = arg0_33.rightPanel:Find("filtrate/filtrate_sort/tag_up")

	local function var2_33()
		setActive(var0_33, arg0_33.dressSortType == var1_0.Down_up)
		setActive(var1_33, arg0_33.dressSortType == var1_0.Up_Down)
	end

	onButton(arg0_33, var0_33, function()
		arg0_33.dressSortType = var1_0.Up_Down

		var2_33()
		arg0_33:SortDressListByQuality()
	end)
	onButton(arg0_33, var1_33, function()
		arg0_33.dressSortType = var1_0.Down_up

		var2_33()
		arg0_33:SortDressListByQuality()
	end)

	arg0_33.dressObjectPool = {}
	arg0_33.dressSortType = var1_0.Down_up

	arg0_33:GetInitDressData()
	arg0_33:InitCharacter()
	triggerToggle(arg0_33.toggles[var0_0.Footprint], true)
	arg0_33:Flush()
end

function var0_0.OnHide(arg0_37)
	arg0_37:UnloadCharacter()
end

function var0_0.GetInitDressData(arg0_38)
	arg0_38.pageDressDic = {}
	arg0_38.initDressData = getProxy(IslandProxy):GetIsland():GetVisitorAgency():GetPlayerDressData()
end

function var0_0.OnDestroy(arg0_39)
	arg0_39:UnloadCharacter()

	for iter0_39, iter1_39 in pairs(arg0_39.dressCards or {}) do
		-- block empty
	end

	arg0_39.dressCards = nil
end

function var0_0.SaveDressUpData(arg0_40)
	getProxy(IslandProxy):GetIsland():GetVisitorAgency():ChangeDress(arg0_40.pageDressDic)
end

function var0_0.CheckDressIsDirty(arg0_41)
	local var0_41 = getProxy(IslandProxy):GetIsland():GetVisitorAgency():GetPlayerDressData()

	for iter0_41, iter1_41 in pairs(arg0_41.pageDressDic) do
		if var0_41[iter0_41] ~= iter1_41.currentItemId then
			return true
		end
	end

	return false
end

return var0_0
