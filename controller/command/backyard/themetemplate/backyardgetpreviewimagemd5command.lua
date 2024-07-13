local var0_0 = class("BackYardGetPreviewImageMd5Command", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.callback
	local var3_1 = getProxy(DormProxy)
	local var4_1 = arg0_1:GetListByType(var1_1)

	if table.getCount(var4_1) == 0 then
		if var2_1 then
			var2_1()
		end

		return
	end

	local var5_1 = {}

	for iter0_1, iter1_1 in pairs(var4_1) do
		table.insert(var5_1, iter1_1.id)
	end

	pg.ConnectionMgr.GetInstance():Send(19131, {
		id_list = var5_1
	}, 19132, function(arg0_2)
		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.list) do
			var0_2[iter1_2.id] = iter1_2.md5
		end

		for iter2_2, iter3_2 in pairs(var4_1) do
			if not var0_2[iter3_2.id] then
				arg0_1:DeleteByType(var1_1, iter3_2.id)
			else
				arg0_1:UpdateMd5ByType(var1_1, iter3_2.id, var0_2[iter3_2.id])
			end
		end

		if var2_1 then
			var2_1()
		end
	end)
end

function var0_0.GetListByType(arg0_3, arg1_3)
	local var0_3 = getProxy(DormProxy)

	if arg1_3 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		return var0_3:GetShopThemeTemplates()
	elseif arg1_3 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		return var0_3:GetCollectionThemeTemplates()
	end

	assert(false)
end

function var0_0.DeleteByType(arg0_4, arg1_4, arg2_4)
	local var0_4 = getProxy(DormProxy)

	if arg1_4 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		var0_4:DeleteShopThemeTemplate(arg2_4)
	elseif arg1_4 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		var0_4:DeleteCollectionThemeTemplate(arg2_4)
	end
end

function var0_0.UpdateMd5ByType(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = getProxy(DormProxy)
	local var1_5

	if arg1_5 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		var1_5 = var0_5:GetShopThemeTemplateById(arg2_5)
	elseif arg1_5 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		var1_5 = var0_5:GetCollectionThemeTemplateById(arg2_5)
	end

	if var1_5 then
		var1_5:UpdateIconMd5(arg3_5)
	end
end

return var0_0
