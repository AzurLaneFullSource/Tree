local var0_0 = class("GetAllBackYardThemeTemplateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback
	local var1_1 = {}
	local var2_1 = {}
	local var3_1 = {}

	seriesAsync({
		function(arg0_2)
			arg0_1:GetCustomThemeTemplate(function(arg0_3)
				var2_1 = arg0_3

				arg0_2()
			end)
		end,
		function(arg0_4)
			arg0_1:GetShopThemeTemplate(function(arg0_5)
				var1_1 = arg0_5

				arg0_4()
			end)
		end,
		function(arg0_6)
			arg0_1:GetCollectionThemeTemplate(function(arg0_7)
				var3_1 = arg0_7

				arg0_6()
			end)
		end
	}, function()
		if var0_1 then
			var0_1(var1_1, var2_1, var3_1)
		end
	end)
end

local function var1_0(arg0_9, arg1_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg1_9 or {}) do
		table.insert(var0_9, iter1_9)
	end

	return var0_9
end

function var0_0.GetCustomThemeTemplate(arg0_10, arg1_10)
	local var0_10 = getProxy(DormProxy)
	local var1_10 = var0_10:GetCustomThemeTemplates()

	if not var1_10 then
		arg0_10:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE, {
			type = BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM,
			callback = function()
				var1_10 = var0_10:GetCustomThemeTemplates()

				arg1_10(var1_0(arg0_10, var1_10))
			end
		})
	else
		arg1_10(var1_0(arg0_10, var1_10))
	end
end

function var0_0.GetShopThemeTemplate(arg0_12, arg1_12)
	local var0_12 = {}

	getProxy(DormProxy):SetShopThemeTemplates(var0_12)
	arg1_12(var0_12)
end

function var0_0.GetCollectionThemeTemplate(arg0_13, arg1_13)
	local var0_13 = getProxy(DormProxy)
	local var1_13 = var0_13:GetCollectionThemeTemplates()

	if not var1_13 then
		arg0_13:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE, {
			type = BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION,
			callback = function()
				var1_13 = var0_13:GetCollectionThemeTemplates()

				arg1_13(var1_0(arg0_13, var1_13))
			end
		})
	else
		arg1_13(var1_0(arg0_13, var1_13))
	end
end

return var0_0
