local var0_0 = class("IslandAchievementCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
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
end

function var0_0.UpdataData(arg0_6)
	setText(arg0_6.nameTF, arg0_6.achv:getConfig("name"))

	local var0_6 = arg0_6.achvAgency:GetCurProgress(arg0_6.achv)
	local var1_6 = arg0_6.achv:GetNum()
	local var2_6 = string.gsub(arg0_6.achv:getConfig("desc"), "$1", var0_6)
	local var3_6 = string.gsub(var2_6, "$2", var1_6)

	setText(arg0_6.descTF, var3_6)

	local var4_6 = arg0_6.achv:GetStatus()

	setActive(arg0_6.gotTF, var4_6 == IslandAchievement.STATUS.GOT)
	setActive(arg0_6.getBtn, var4_6 == IslandAchievement.STATUS.GET)

	local var5_6 = var4_6 == IslandAchievement.STATUS.NORMAL

	setActive(arg0_6.goTF, var5_6)

	if var5_6 then
		setText(arg0_6.goTF:Find("Text"), var0_6 .. "/" .. var1_6)
	end

	arg0_6.awards = arg0_6.achv:GetAwards()

	arg0_6.awardUIList:align(#arg0_6.awards)
end

function var0_0.Update(arg0_7, arg1_7)
	arg0_7.achv = arg1_7
	arg0_7.achvAgency = getProxy(IslandProxy):GetIsland():GetAchievementAgency()

	arg0_7:UpdataData()

	local var0_7 = arg0_7.achv:getConfig("group")
	local var1_7 = arg0_7.achvAgency:GetGroup(var0_7)

	arg0_7.stageAchvs = underscore.select(var1_7:GetSortAchvList(), function(arg0_8)
		return not arg0_8:IsHideType() or arg0_8:GetStatus() == IslandAchievement.STATUS.GET
	end)

	arg0_7.stageUIList:align(#arg0_7.stageAchvs)
end

function var0_0.PlayStageAnim(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.stageUIList.container:Find(tostring(arg1_9))
	local var1_9 = var0_9:GetComponent(typeof(DftAniEvent))

	var1_9:SetEndEvent(function()
		existCall(arg2_9)
		var1_9:SetEndEvent(nil)
	end)
	var0_9:GetComponent(typeof(Animation)):Play()
end

function var0_0.Dispose(arg0_11)
	return
end

return var0_0
