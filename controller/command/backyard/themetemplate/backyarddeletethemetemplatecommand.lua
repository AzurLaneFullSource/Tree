local var0 = class("BackYardDeleteThemeTemplateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().templateId
	local var1 = getProxy(DormProxy)
	local var2 = var1:GetCustomThemeTemplateById(var0)

	local function var3(arg0)
		if not var2:IsPushed() then
			if arg0 then
				arg0()
			end

			return
		end

		pg.UIMgr.GetInstance():LoadingOn()
		seriesAsync({
			function(arg0)
				BackYardThemeTempalteUtil.DeleteTexture(var2:GetTextureName(), function(arg0)
					if arg0 then
						arg0()
					end
				end)
			end,
			function(arg0)
				BackYardThemeTempalteUtil.DeleteTexture(var2:GetTextureIconName(), function(arg0)
					if arg0 then
						arg0()
					end
				end)
			end
		}, function()
			pg.UIMgr.GetInstance():LoadingOff()

			if arg0 then
				arg0()
			end
		end)
	end

	local function var4(arg0)
		BackYardThemeTempalteUtil.ClearCaches({
			var2:GetTextureName(),
			var2:GetTextureIconName()
		})
		var1:DeleteCustomThemeTemplate(var0)

		if var1:IsInitShopThemeTemplates() then
			if var1:GetShopThemeTemplateById(var0) then
				var1:DeleteShopThemeTemplate(var0)
			end

			if var1:GetCollectionThemeTemplateById(var0) then
				var1:DeleteCollectionThemeTemplate(var0)
			end
		end

		arg0:sendNotification(GAME.BACKYARD_DELETE_THEME_TEMPLATE_DONE)
	end

	;(function()
		pg.ConnectionMgr.GetInstance():Send(19123, {
			pos = var2.pos
		}, 19124, function(arg0)
			if arg0.result == 0 then
				var4(arg0)
				var3()
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end
		end)
	end)()
end

return var0
