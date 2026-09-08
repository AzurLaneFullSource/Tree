local var0_0 = class("ReversePacmanBuffSubView", import("view.base.BaseSubView"))

var0_0.LOCAL_SAVE_KEY = "ReversePacmanBuff"

function var0_0.getUIName(arg0_1)
	return "ReversePacmanBuffPanel"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.uiMaskTF, function()
		arg0_3:Hide()
	end, SOUND_BACK)
	onButton(arg0_3, arg0_3.uiCloseBtn, function()
		arg0_3:Hide()
	end, SOUND_BACK)

	arg0_3.buffUIList = UIItemList.New(arg0_3.uiContentTF, arg0_3.uiContentTF:Find("tpl"))

	arg0_3.buffUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventInit then
			arg0_3:InitBuffTpl(arg1_6, arg2_6)
		elseif arg0_6 == UIItemList.EventUpdate then
			arg0_3:UpdateBuffTpl(arg1_6, arg2_6)
		end
	end)

	arg0_3.slotUIList = UIItemList.New(arg0_3.uiSlotsTF, arg0_3.uiSlotsTF:Find("tpl"))

	arg0_3.slotUIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg0_3:UpdateSlotTpl(arg1_7, arg2_7)
		end
	end)
end

function var0_0.Show(arg0_8, arg1_8, arg2_8)
	var0_0.super.Show(arg0_8)
	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf)

	arg0_8.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_REVERSE_PACMAN)
	arg0_8.slotCnt = arg1_8
	arg0_8.selSlot = 1
	arg0_8.owndBuffIds, arg0_8.owndBuffCnts = arg0_8:GetOwndBuffs()
	arg0_8.selBuffIds = var0_0.GetSelBuffIds(arg0_8.slotCnt)

	arg0_8.buffUIList:align(#arg0_8.owndBuffIds)
	arg0_8.slotUIList:align(arg0_8.slotCnt)

	arg0_8.hideCallback = arg2_8
end

function var0_0.GetOwndBuffs(arg0_9)
	local var0_9 = {}
	local var1_9 = {}

	for iter0_9, iter1_9 in pairs(ReversePacmanConst.BUFF) do
		local var2_9 = pg.activity_chasing_skill[iter1_9].item_id
		local var3_9 = arg0_9.activity:GetVitemNumber(var2_9)

		if var3_9 > 0 then
			table.insert(var0_9, iter1_9)
			table.insert(var1_9, var3_9)
		end
	end

	return var0_9, var1_9
end

function var0_0.UpdateSlotTpl(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg1_10 + 1
	local var1_10 = arg0_10.selBuffIds[var0_10]
	local var2_10 = var1_10 == 0

	setActive(arg2_10:Find("empty"), var2_10)
	setActive(arg2_10:Find("icon"), not var2_10)
	setActive(arg2_10:Find("Text"), false)

	if not var2_10 then
		LoadImageSpriteAsync(pg.activity_chasing_skill[var1_10].icon, arg2_10:Find("icon"))
	end
end

function var0_0.InitBuffTpl(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.owndBuffIds[arg1_11 + 1]
	local var1_11 = arg0_11.owndBuffCnts[arg1_11 + 1]
	local var2_11 = pg.activity_chasing_skill[var0_11]

	arg2_11.name = tostring(var0_11)

	setText(arg2_11:Find("content/name"), var2_11.name)

	local var3_11 = string.gsub(var2_11.desc, "$1", var2_11.param)

	setText(arg2_11:Find("content/desc"), var3_11)
	setText(arg2_11:Find("content/count"), var1_11)
	LoadImageSpriteAsync(var2_11.icon, arg2_11:Find("icon"))
end

function var0_0.UpdateBuffTpl(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.owndBuffIds[arg1_12 + 1]
	local var1_12 = table.contains(arg0_12.selBuffIds, var0_12)

	setActive(arg2_12:Find("toggle/sel"), var1_12)

	local var2_12 = underscore.all(arg0_12.selBuffIds, function(arg0_13)
		return arg0_13 ~= 0
	end)
	local var3_12 = not var1_12 and var2_12

	setGray(arg2_12:Find("toggle"), var3_12)
	onButton(arg0_12, arg2_12:Find("toggle"), function()
		if var3_12 then
			return
		end

		if var1_12 then
			local var0_14 = table.indexof(arg0_12.selBuffIds, var0_12)

			arg0_12.selBuffIds[var0_14] = 0
		else
			local var1_14 = (function()
				for iter0_15, iter1_15 in ipairs(arg0_12.selBuffIds) do
					if iter1_15 == 0 then
						return iter0_15
					end
				end
			end)()

			arg0_12.selBuffIds[var1_14] = var0_12
		end

		arg0_12:SortAndSaveSelIds()
		arg0_12.slotUIList:align(arg0_12.slotCnt)
		arg0_12.buffUIList:align(#arg0_12.owndBuffIds)
	end, SFX_PANEL)
end

function var0_0.SortAndSaveSelIds(arg0_16)
	local var0_16 = {}

	for iter0_16, iter1_16 in ipairs(arg0_16.selBuffIds) do
		if iter1_16 ~= 0 then
			table.insert(var0_16, iter1_16)
		end
	end

	for iter2_16 = 1, arg0_16.slotCnt do
		if var0_16[iter2_16] == nil then
			var0_16[iter2_16] = 0
		end

		var0_0.SetLocalBuffData(iter2_16, var0_16[iter2_16])
	end

	arg0_16.selBuffIds = var0_16
end

function var0_0.Hide(arg0_17)
	var0_0.super.Hide(arg0_17)
	existCall(arg0_17.hideCallback)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_17._tf)
end

function var0_0.OnDestroy(arg0_18)
	return
end

function var0_0.GetLocalBuffData(arg0_19)
	local var0_19 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var0_0.LOCAL_SAVE_KEY .. "_" .. var0_19 .. "_" .. arg0_19) or 0
end

function var0_0.SetLocalBuffData(arg0_20, arg1_20)
	local var0_20 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0_0.LOCAL_SAVE_KEY .. "_" .. var0_20 .. "_" .. arg0_20, arg1_20)
	PlayerPrefs.Save()
end

function var0_0.GetSelBuffIds(arg0_21)
	local var0_21 = {}

	for iter0_21 = 1, arg0_21 do
		table.insert(var0_21, var0_0.GetLocalBuffData(iter0_21))
	end

	return var0_21
end

return var0_0
