local var0 = class("BackYardUploadThemeTemplateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().templateId
	local var1 = getProxy(DormProxy)
	local var2 = var1:GetCustomThemeTemplateById(var0)

	local function var3(arg0)
		pg.UIMgr.GetInstance():LoadingOn()
		seriesAsync({
			function(arg0)
				BackYardThemeTempalteUtil.UploadTexture(var2:GetTextureName(), function(arg0)
					if arg0 then
						arg0()
					end
				end)
			end,
			function(arg0)
				BackYardThemeTempalteUtil.UploadTexture(var2:GetTextureIconName(), function(arg0)
					if arg0 then
						arg0()
					end
				end)
			end
		}, function()
			pg.UIMgr.GetInstance():LoadingOff()
			arg0()
		end)
	end

	local function var4(arg0)
		var2:Upload()
		var1:UpdateCustomThemeTemplate(var2)
		arg0:sendNotification(GAME.BACKYARD_UPLOAD_THEME_TEMPLATE_DONE)
	end

	local function var5()
		pg.ConnectionMgr.GetInstance():Send(19111, {
			pos = var2.pos
		}, 19112, function(arg0)
			if arg0.result == 0 then
				var4(arg0)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end
		end)
	end

	var3(function()
		var5()
	end)
end

return var0
