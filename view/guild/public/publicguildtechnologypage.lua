local var0 = class("PublicGuildTechnologyPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "PublicGuildTechnologyPage"
end

function var0.OnTechGroupUpdate(arg0, arg1)
	arg0:UpdateUpgradeList()
end

function var0.OnLoaded(arg0)
	arg0.upgradeList = UIItemList.New(arg0:findTF("frame/upgrade/content"), arg0:findTF("frame/upgrade/content/tpl"))
end

function var0.OnInit(arg0)
	arg0.upgradeList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.technologyVOs[arg1 + 1]

			PublicGuildTechnologyCard.New(arg2:Find("content"), arg0):Update(var0)
			setActive(arg2:Find("back"), false)
		end
	end)
end

function var0.Show(arg0, arg1)
	arg0.guildVO = arg1

	arg0:UpdateUpgradeList()
	var0.super.Show(arg0)
end

function var0.UpdateUpgradeList(arg0)
	arg0.technologyVOs = {}

	local var0 = arg0.guildVO:GetTechnologys()

	for iter0, iter1 in pairs(var0) do
		if not iter1:IsGuildMember() then
			table.insert(arg0.technologyVOs, iter1)
		end
	end

	table.sort(arg0.technologyVOs, function(arg0, arg1)
		return arg0.id < arg1.id
	end)
	arg0.upgradeList:align(#arg0.technologyVOs)
end

function var0.OnDestroy(arg0)
	return
end

return var0
