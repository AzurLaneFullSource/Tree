local var0_0 = class("BackYardDeleteThemeTemplateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().templateId
	local var1_1 = getProxy(DormProxy)
	local var2_1 = var1_1:GetCustomThemeTemplateById(var0_1)

	local function var3_1(arg0_2)
		if not var2_1:IsPushed() then
			if arg0_2 then
				arg0_2()
			end

			return
		end

		pg.UIMgr.GetInstance():LoadingOn()
		seriesAsync({
			function(arg0_3)
				BackYardThemeTempalteUtil.DeleteTexture(var2_1:GetTextureName(), function(arg0_4)
					if arg0_4 then
						arg0_3()
					end
				end)
			end,
			function(arg0_5)
				BackYardThemeTempalteUtil.DeleteTexture(var2_1:GetTextureIconName(), function(arg0_6)
					if arg0_6 then
						arg0_5()
					end
				end)
			end
		}, function()
			pg.UIMgr.GetInstance():LoadingOff()

			if arg0_2 then
				arg0_2()
			end
		end)
	end

	local function var4_1(arg0_8)
		BackYardThemeTempalteUtil.ClearCaches({
			var2_1:GetTextureName(),
			var2_1:GetTextureIconName()
		})
		var1_1:DeleteCustomThemeTemplate(var0_1)

		if var1_1:IsInitShopThemeTemplates() then
			if var1_1:GetShopThemeTemplateById(var0_1) then
				var1_1:DeleteShopThemeTemplate(var0_1)
			end

			if var1_1:GetCollectionThemeTemplateById(var0_1) then
				var1_1:DeleteCollectionThemeTemplate(var0_1)
			end
		end

		arg0_1:sendNotification(GAME.BACKYARD_DELETE_THEME_TEMPLATE_DONE)
	end

	;(function()
		pg.ConnectionMgr.GetInstance():Send(19123, {
			pos = var2_1.pos
		}, 19124, function(arg0_10)
			if arg0_10.result == 0 then
				var4_1(arg0_10)
				var3_1()
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_10.result] .. arg0_10.result)
			end
		end)
	end)()
end

return var0_0
