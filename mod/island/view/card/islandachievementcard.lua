local var0_0 = class("IslandAchievementCard")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.parent = arg2_1
	arg0_1.nameTF = arg0_1._tf:Find("name")
	arg0_1.descTF = arg0_1._tf:Find("desc")
	arg0_1.goTF = arg0_1._tf:Find("status/go")
	arg0_1.getBtn = arg0_1._tf:Find("status/get")
	arg0_1.gotTF = arg0_1._tf:Find("status/got")
	arg0_1.lockTF = arg0_1._tf:Find("lock")

	local var0_1 = arg0_1._tf:Find("stages")

	arg0_1.stageUIList = UIItemList.New(var0_1, var0_1:Find("tpl"))

	arg0_1.stageUIList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			arg0_1:UpdateStageItem(arg1_2, arg2_2)
		end
	end)

	local var1_1 = arg0_1._tf:Find("awards")

	arg0_1.awardUIList = UIItemList.New(var1_1, var1_1:Find("tpl"))

	arg0_1.awardUIList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			arg0_1:UpdateAwardItem(arg1_3, arg2_3)
		end
	end)
end

function var0_0.UpdateStageItem(arg0_4, arg1_4, arg2_4)
	arg2_4:GetComponent(typeof(Animation)):Stop()

	local var0_4 = arg1_4 + 1

	GetImageSpriteFromAtlasAsync("islandachievement", "achv_stage_" .. var0_4, arg2_4:Find("icon"))

	local var1_4 = var0_4 == 1
	local var2_4 = arg0_4.stageAchvs[var0_4]

	arg2_4.name = var2_4.id

	setActive(arg2_4:Find("line"), not var1_4)

	local var3_4 = var2_4:GetStatus() == IslandAchievement.STATUS.GOT

	setActive(arg2_4:Find("line/got"), var3_4)
	setActive(arg2_4:Find("circle/got"), var3_4)
end

function var0_0.UpdateAwardItem(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5.awards[arg1_5 + 1]

	GetImageSpriteFromAtlasAsync(var0_5:getIcon(), "", arg2_5:Find("icon"))
	setText(arg2_5:Find("count"), var0_5.count)
	onButton(arg0_5.parent, arg2_5, function()
		arg0_5.parent:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var0_5
		})
	end)
end

function var0_0.UpdataData(arg0_7)
	setText(arg0_7.nameTF, arg0_7.achv:getConfig("name"))

	local var0_7 = arg0_7.achvAgency:GetCurProgress(arg0_7.achv)
	local var1_7 = arg0_7.achv:GetNum()
	local var2_7 = string.gsub(arg0_7.achv:getConfig("desc"), "$1", var0_7)
	local var3_7 = string.gsub(var2_7, "$2", var1_7)

	setText(arg0_7.descTF, var3_7)

	local var4_7 = arg0_7.achv:GetStatus()

	setActive(arg0_7.gotTF, var4_7 == IslandAchievement.STATUS.GOT)
	setActive(arg0_7.getBtn, var4_7 == IslandAchievement.STATUS.GET)

	local var5_7 = var4_7 == IslandAchievement.STATUS.NORMAL

	setActive(arg0_7.goTF, var5_7)

	if var5_7 then
		setText(arg0_7.goTF:Find("Text"), var0_7 .. "/" .. var1_7)
	end

	arg0_7.awards = arg0_7.achv:GetAwards()

	arg0_7.awardUIList:align(#arg0_7.awards)
end

function var0_0.Update(arg0_8, arg1_8)
	arg0_8.achv = arg1_8
	arg0_8.achvAgency = getProxy(IslandProxy):GetIsland():GetAchievementAgency()

	arg0_8:UpdataData()

	local var0_8 = arg0_8.achv:getConfig("group")
	local var1_8 = arg0_8.achvAgency:GetGroup(var0_8)

	arg0_8.stageAchvs = underscore.select(var1_8:GetSortAchvList(), function(arg0_9)
		return not arg0_9:IsHideType() or arg0_9:GetStatus() == IslandAchievement.STATUS.GET
	end)

	arg0_8.stageUIList:align(#arg0_8.stageAchvs)
end

function var0_0.PlayStageAnim(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.stageUIList.container:Find(tostring(arg1_10))
	local var1_10 = var0_10:GetComponent(typeof(DftAniEvent))

	var1_10:SetEndEvent(function()
		existCall(arg2_10)
		var1_10:SetEndEvent(nil)
	end)
	var0_10:GetComponent(typeof(Animation)):Play()
end

function var0_0.Dispose(arg0_12)
	return
end

return var0_0
