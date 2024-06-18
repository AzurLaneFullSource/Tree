local var0_0 = class("PublicGuildTechnologyPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "PublicGuildTechnologyPage"
end

function var0_0.OnTechGroupUpdate(arg0_2, arg1_2)
	arg0_2:UpdateUpgradeList()
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.upgradeList = UIItemList.New(arg0_3:findTF("frame/upgrade/content"), arg0_3:findTF("frame/upgrade/content/tpl"))
end

function var0_0.OnInit(arg0_4)
	arg0_4.upgradeList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg0_4.technologyVOs[arg1_5 + 1]

			PublicGuildTechnologyCard.New(arg2_5:Find("content"), arg0_4):Update(var0_5)
			setActive(arg2_5:Find("back"), false)
		end
	end)
end

function var0_0.Show(arg0_6, arg1_6)
	arg0_6.guildVO = arg1_6

	arg0_6:UpdateUpgradeList()
	var0_0.super.Show(arg0_6)
end

function var0_0.UpdateUpgradeList(arg0_7)
	arg0_7.technologyVOs = {}

	local var0_7 = arg0_7.guildVO:GetTechnologys()

	for iter0_7, iter1_7 in pairs(var0_7) do
		if not iter1_7:IsGuildMember() then
			table.insert(arg0_7.technologyVOs, iter1_7)
		end
	end

	table.sort(arg0_7.technologyVOs, function(arg0_8, arg1_8)
		return arg0_8.id < arg1_8.id
	end)
	arg0_7.upgradeList:align(#arg0_7.technologyVOs)
end

function var0_0.OnDestroy(arg0_9)
	return
end

return var0_0
