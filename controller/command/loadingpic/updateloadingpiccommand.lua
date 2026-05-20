local var0_0 = class("UpdateLoadingPicCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.diyModeOpenFlag

	if var1_1 == nil then
		var1_1 = var0_1.loading_pic_open_flag
	end

	local var2_1 = var0_1.galleryPicIDList or var0_1.loading_pic_id_list_1
	local var3_1 = var0_1.mangaPicIDList or var0_1.loading_pic_id_list_2
	local var4_1 = var0_1.callback
	local var5_1 = getProxy(LoadingPicProxy)

	if var1_1 == nil then
		var1_1 = var5_1:getDiyModeOpenFlag()
	end

	if var2_1 == nil then
		var2_1 = var5_1:getGalleryPicIDList()
	end

	if var3_1 == nil then
		var3_1 = var5_1:getMangaPicIDList()
	end

	if #var2_1 + #var3_1 > AppreciatePicConst.MAX_COUNT then
		pg.TipsMgr.GetInstance():ShowTips(i18n("loading_pic_max"))

		return
	end

	local var6_1 = var1_1 == true and 1 or 0
	local var7_1 = {
		loading_pic_open_flag = var6_1,
		loading_pic_id_list_1 = var2_1,
		loading_pic_id_list_2 = var3_1
	}

	pg.ConnectionMgr.GetInstance():Send(11034, var7_1, 11035, function(arg0_2)
		if arg0_2.result == 0 then
			var5_1:updateDiyModeOpenFlag(var6_1)
			var5_1:updateGalleryPicIDList(var2_1)
			var5_1:updateMangaPicIDList(var3_1)
			pg.m02:sendNotification(GAME.UPDATE_LOADING_PIC_DONE, var7_1)

			if var4_1 then
				var4_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
