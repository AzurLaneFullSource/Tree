local var0 = class("GetAllBackYardThemeTemplateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().callback
	local var1 = {}
	local var2 = {}
	local var3 = {}

	seriesAsync({
		function(arg0)
			arg0:GetCustomThemeTemplate(function(arg0)
				var2 = arg0

				arg0()
			end)
		end,
		function(arg0)
			arg0:GetShopThemeTemplate(function(arg0)
				var1 = arg0

				arg0()
			end)
		end,
		function(arg0)
			arg0:GetCollectionThemeTemplate(function(arg0)
				var3 = arg0

				arg0()
			end)
		end
	}, function()
		if var0 then
			var0(var1, var2, var3)
		end
	end)
end

local function var1(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg1 or {}) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.GetCustomThemeTemplate(arg0, arg1)
	local var0 = getProxy(DormProxy)
	local var1 = var0:GetCustomThemeTemplates()

	if not var1 then
		arg0:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE, {
			type = BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM,
			callback = function()
				var1 = var0:GetCustomThemeTemplates()

				arg1(var1(arg0, var1))
			end
		})
	else
		arg1(var1(arg0, var1))
	end
end

function var0.GetShopThemeTemplate(arg0, arg1)
	local var0 = {}

	getProxy(DormProxy):SetShopThemeTemplates(var0)
	arg1(var0)
end

function var0.GetCollectionThemeTemplate(arg0, arg1)
	local var0 = getProxy(DormProxy)
	local var1 = var0:GetCollectionThemeTemplates()

	if not var1 then
		arg0:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE, {
			type = BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION,
			callback = function()
				var1 = var0:GetCollectionThemeTemplates()

				arg1(var1(arg0, var1))
			end
		})
	else
		arg1(var1(arg0, var1))
	end
end

return var0
