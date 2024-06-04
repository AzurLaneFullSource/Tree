local var0 = class("BackYardGetPreviewImageMd5Command", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.type
	local var2 = var0.callback
	local var3 = getProxy(DormProxy)
	local var4 = arg0:GetListByType(var1)

	if table.getCount(var4) == 0 then
		if var2 then
			var2()
		end

		return
	end

	local var5 = {}

	for iter0, iter1 in pairs(var4) do
		table.insert(var5, iter1.id)
	end

	pg.ConnectionMgr.GetInstance():Send(19131, {
		id_list = var5
	}, 19132, function(arg0)
		local var0 = {}

		for iter0, iter1 in ipairs(arg0.list) do
			var0[iter1.id] = iter1.md5
		end

		for iter2, iter3 in pairs(var4) do
			if not var0[iter3.id] then
				arg0:DeleteByType(var1, iter3.id)
			else
				arg0:UpdateMd5ByType(var1, iter3.id, var0[iter3.id])
			end
		end

		if var2 then
			var2()
		end
	end)
end

function var0.GetListByType(arg0, arg1)
	local var0 = getProxy(DormProxy)

	if arg1 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		return var0:GetShopThemeTemplates()
	elseif arg1 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		return var0:GetCollectionThemeTemplates()
	end

	assert(false)
end

function var0.DeleteByType(arg0, arg1, arg2)
	local var0 = getProxy(DormProxy)

	if arg1 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		var0:DeleteShopThemeTemplate(arg2)
	elseif arg1 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		var0:DeleteCollectionThemeTemplate(arg2)
	end
end

function var0.UpdateMd5ByType(arg0, arg1, arg2, arg3)
	local var0 = getProxy(DormProxy)
	local var1

	if arg1 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		var1 = var0:GetShopThemeTemplateById(arg2)
	elseif arg1 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		var1 = var0:GetCollectionThemeTemplateById(arg2)
	end

	if var1 then
		var1:UpdateIconMd5(arg3)
	end
end

return var0
