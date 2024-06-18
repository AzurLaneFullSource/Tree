local var0_0 = class("AppreciateProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1:initData()
	arg0_1:checkPicFileState()
	arg0_1:checkMusicFileState()
end

function var0_0.initData(arg0_2)
	arg0_2.picManager = BundleWizard.Inst:GetGroupMgr("GALLERY_PIC")
	arg0_2.musicManager = BundleWizard.Inst:GetGroupMgr("GALLERY_BGM")
	arg0_2.reForVer = PathMgr.MD5Result
	arg0_2.galleryPicUnLockIDLIst = {}
	arg0_2.galleryPicExistStateTable = {}
	arg0_2.galleryPicLikeIDList = {}
	arg0_2.musicUnLockIDLIst = {}
	arg0_2.musicExistStateTable = {}
	arg0_2.musicLikeIDList = {}
	arg0_2.mangaReadIDList = {}
	arg0_2.mangaLikeIDList = {}
	arg0_2.galleryRunData = {
		middleIndex = 1,
		dateValue = GalleryConst.Data_All_Value,
		sortValue = GalleryConst.Sort_Order_Up,
		likeValue = GalleryConst.Filte_Normal_Value,
		bgFilteValue = GalleryConst.Loading_BG_NO_Filte
	}
	arg0_2.musicRunData = {
		middleIndex = 1,
		sortValue = MusicCollectionConst.Sort_Order_Up,
		likeValue = MusicCollectionConst.Filte_Normal_Value
	}
end

function var0_0.checkPicFileState(arg0_3)
	local var0_3
	local var1_3

	for iter0_3, iter1_3 in ipairs(pg.gallery_config.all) do
		local var2_3 = pg.gallery_config[iter1_3].illustration
		local var3_3 = GalleryConst.PIC_PATH_PREFIX .. var2_3
		local var4_3 = checkABExist(var3_3)

		arg0_3.galleryPicExistStateTable[iter1_3] = var4_3
	end
end

function var0_0.checkMusicFileState(arg0_4)
	local var0_4
	local var1_4

	for iter0_4, iter1_4 in ipairs(pg.music_collect_config.all) do
		local var2_4 = pg.music_collect_config[iter1_4].music
		local var3_4 = MusicCollectionConst.MUSIC_SONG_PATH_PREFIX .. var2_4 .. ".b"
		local var4_4 = checkABExist(var3_4)

		arg0_4.musicExistStateTable[iter1_4] = var4_4
	end
end

function var0_0.updatePicFileExistStateTable(arg0_5, arg1_5, arg2_5)
	arg0_5.galleryPicExistStateTable[arg1_5] = arg2_5
end

function var0_0.updateMusicFileExistStateTable(arg0_6, arg1_6, arg2_6)
	arg0_6.musicExistStateTable[arg1_6] = arg2_6
end

function var0_0.getPicExistStateByID(arg0_7, arg1_7)
	if not arg1_7 then
		assert("不能为空的picID:" .. tostring(arg1_7))
	end

	return arg0_7.galleryPicExistStateTable[arg1_7]
end

function var0_0.getMusicExistStateByID(arg0_8, arg1_8)
	if not arg1_8 then
		assert("不能为空的musicID:" .. tostring(arg1_8))
	end

	return arg0_8.musicExistStateTable[arg1_8]
end

function var0_0.getSinglePicConfigByID(arg0_9, arg1_9)
	local var0_9 = pg.gallery_config[arg1_9]

	if var0_9 then
		return var0_9
	else
		assert(false, "不存在的插画ID:" .. tostring(arg1_9))
	end
end

function var0_0.getSingleMusicConfigByID(arg0_10, arg1_10)
	local var0_10 = pg.music_collect_config[arg1_10]

	if var0_10 then
		return var0_10
	else
		assert(false, "不存在的音乐ID:" .. tostring(arg1_10))
	end
end

function var0_0.updateGalleryRunData(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11, arg5_11)
	arg0_11.galleryRunData.dateValue = arg1_11 and arg1_11 or arg0_11.galleryRunData.dateValue
	arg0_11.galleryRunData.sortValue = arg2_11 and arg2_11 or arg0_11.galleryRunData.sortValue
	arg0_11.galleryRunData.middleIndex = arg3_11 and arg3_11 or arg0_11.galleryRunData.middleIndex
	arg0_11.galleryRunData.likeValue = arg4_11 and arg4_11 or arg0_11.galleryRunData.likeValue
	arg0_11.galleryRunData.bgFilteValue = arg5_11 and arg5_11 or arg0_11.galleryRunData.bgFilteValue
end

function var0_0.updateMusicRunData(arg0_12, arg1_12, arg2_12, arg3_12)
	arg0_12.musicRunData.sortValue = arg1_12 and arg1_12 or arg0_12.musicRunData.sortValue
	arg0_12.musicRunData.middleIndex = arg2_12 and arg2_12 or arg0_12.musicRunData.middleIndex
	arg0_12.musicRunData.likeValue = arg3_12 and arg3_12 or arg0_12.musicRunData.likeValue
end

function var0_0.getGalleryRunData(arg0_13, arg1_13)
	return arg0_13.galleryRunData
end

function var0_0.getMusicRunData(arg0_14, arg1_14)
	return arg0_14.musicRunData
end

function var0_0.isPicNeedUnlockByID(arg0_15, arg1_15)
	local var0_15 = arg0_15:getPicUnlockMaterialByID(arg1_15)
	local var1_15 = arg0_15:getSinglePicConfigByID(arg1_15)

	if var1_15 then
		local var2_15 = var1_15.unlock_level

		if var2_15[1] == 1 and var2_15[2] == 0 then
			if #var0_15 == 0 then
				return false
			else
				return true
			end
		else
			return true
		end
	else
		assert(false, "不存在的插画ID:" .. arg1_15)
	end
end

function var0_0.isMusicNeedUnlockByID(arg0_16, arg1_16)
	local var0_16 = arg0_16:getMusicUnlockMaterialByID(arg1_16)
	local var1_16 = arg0_16:getSingleMusicConfigByID(arg1_16)

	if var1_16 then
		local var2_16 = var1_16.unlock_level

		if var2_16[1] == 1 and var2_16[2] == 0 then
			if #var0_16 == 0 then
				return false
			else
				return true
			end
		else
			return true
		end
	else
		assert(false, "不存在的音乐ID:" .. arg1_16)
	end
end

function var0_0.getPicUnlockMaterialByID(arg0_17, arg1_17)
	local var0_17 = arg0_17:getSinglePicConfigByID(arg1_17)

	if var0_17 then
		local var1_17 = var0_17.unlock_cost
		local var2_17 = {}

		for iter0_17, iter1_17 in ipairs(var1_17) do
			local var3_17 = {
				type = iter1_17[1],
				id = iter1_17[2],
				count = iter1_17[3]
			}

			var2_17[#var2_17 + 1] = var3_17
		end

		return var2_17
	else
		assert(false, "不存在的插画ID:" .. arg1_17)
	end
end

function var0_0.getMusicUnlockMaterialByID(arg0_18, arg1_18)
	local var0_18 = arg0_18:getSingleMusicConfigByID(arg1_18)

	if var0_18 then
		local var1_18 = var0_18.unlock_cost
		local var2_18 = {}

		for iter0_18, iter1_18 in ipairs(var1_18) do
			local var3_18 = {
				type = iter1_18[1],
				id = iter1_18[2],
				count = iter1_18[3]
			}

			var2_18[#var2_18 + 1] = var3_18
		end

		return var2_18
	else
		assert(false, "不存在的音乐ID:" .. arg1_18)
	end
end

function var0_0.isPicNeedUnlockMaterialByID(arg0_19, arg1_19)
	local var0_19 = arg0_19:getPicUnlockMaterialByID(arg1_19)

	if #var0_19 == 0 then
		return false
	else
		return var0_19
	end
end

function var0_0.isMusicNeedUnlockMaterialByID(arg0_20, arg1_20)
	local var0_20 = arg0_20:getMusicUnlockMaterialByID(arg1_20)

	if #var0_20 == 0 then
		return false
	else
		return var0_20
	end
end

function var0_0.getPicUnlockTipTextByID(arg0_21, arg1_21)
	local var0_21 = arg0_21:getSinglePicConfigByID(arg1_21)

	if var0_21 then
		return var0_21.illustrate
	else
		assert(false, "不存在的插画ID:" .. arg1_21)
	end
end

function var0_0.getMusicUnlockTipTextByID(arg0_22, arg1_22)
	local var0_22 = arg0_22:getSingleMusicConfigByID(arg1_22)

	if var0_22 then
		return var0_22.illustrate
	else
		assert(false, "不存在的音乐ID:" .. arg1_22)
	end
end

function var0_0.getResultForVer(arg0_23)
	return arg0_23.reForVer
end

function var0_0.clearVer(arg0_24)
	arg0_24.reForVer = nil
end

function var0_0.addPicIDToUnlockList(arg0_25, arg1_25)
	if table.contains(arg0_25.galleryPicUnLockIDLIst, arg1_25) then
		print("already exist picID:" .. arg1_25)
	else
		arg0_25.galleryPicUnLockIDLIst[#arg0_25.galleryPicUnLockIDLIst + 1] = arg1_25
	end
end

function var0_0.addMusicIDToUnlockList(arg0_26, arg1_26)
	if table.contains(arg0_26.musicUnLockIDLIst, arg1_26) then
		print("already exist musicID:" .. arg1_26)
	else
		arg0_26.musicUnLockIDLIst[#arg0_26.musicUnLockIDLIst + 1] = arg1_26
	end
end

function var0_0.addMangaIDToReadList(arg0_27, arg1_27)
	if table.contains(arg0_27.mangaReadIDList, arg1_27) then
		print("already exist mangaID:" .. arg1_27)
	else
		table.insert(arg0_27.mangaReadIDList, arg1_27)
	end
end

function var0_0.initMangaReadIDList(arg0_28, arg1_28)
	arg0_28.mangaReadIDList = {}

	for iter0_28, iter1_28 in ipairs(arg1_28) do
		for iter2_28 = 1, 32 do
			if bit.band(iter1_28, bit.lshift(1, iter2_28 - 1)) ~= 0 then
				local var0_28 = (iter0_28 - 1) * 32 + iter2_28

				arg0_28:addMangaIDToReadList(var0_28)
			end
		end
	end

	MangaConst.setVersionAndNewCount()
end

function var0_0.getMangaReadIDList(arg0_29)
	return arg0_29.mangaReadIDList
end

function var0_0.addMangaIDToLikeList(arg0_30, arg1_30)
	if table.contains(arg0_30.mangaLikeIDList, arg1_30) then
		print("already exist mangaID:" .. arg1_30)
	else
		table.insert(arg0_30.mangaLikeIDList, arg1_30)
	end
end

function var0_0.removeMangaIDFromLikeList(arg0_31, arg1_31)
	if table.contains(arg0_31.mangaLikeIDList, arg1_31) then
		table.removebyvalue(arg0_31.mangaLikeIDList, arg1_31, true)
	else
		print("not exist mangaID:" .. arg1_31)
	end
end

function var0_0.initMangaLikeIDList(arg0_32, arg1_32)
	arg0_32.mangaLikeIDList = {}

	for iter0_32, iter1_32 in ipairs(arg1_32) do
		for iter2_32 = 1, 32 do
			if bit.band(iter1_32, bit.lshift(1, iter2_32 - 1)) ~= 0 then
				local var0_32 = (iter0_32 - 1) * 32 + iter2_32

				arg0_32:addMangaIDToLikeList(var0_32)
			end
		end
	end
end

function var0_0.getMangaLikeIDList(arg0_33)
	return arg0_33.mangaLikeIDList
end

function var0_0.isPicUnlockedByID(arg0_34, arg1_34)
	if table.contains(arg0_34.galleryPicUnLockIDLIst, arg1_34) then
		return true
	else
		return false
	end
end

function var0_0.isMusicUnlockedByID(arg0_35, arg1_35)
	if table.contains(arg0_35.musicUnLockIDLIst, arg1_35) then
		return true
	else
		return false
	end
end

function var0_0.isPicUnlockableByID(arg0_36, arg1_36)
	local var0_36 = getProxy(PlayerProxy):getData().level
	local var1_36 = arg0_36:getSinglePicConfigByID(arg1_36)

	if var1_36 then
		local var2_36 = var1_36.unlock_level
		local var3_36 = var2_36[1]
		local var4_36 = var2_36[2]

		if var3_36 <= var0_36 then
			return true
		elseif var4_36 == GalleryConst.Still_Show_On_Lock then
			return false, true
		else
			return false, false
		end
	end
end

function var0_0.isMusicUnlockableByID(arg0_37, arg1_37)
	local var0_37 = getProxy(PlayerProxy):getData().level
	local var1_37 = arg0_37:getSingleMusicConfigByID(arg1_37)

	if var1_37 then
		local var2_37 = var1_37.unlock_level
		local var3_37 = var2_37[1]
		local var4_37 = var2_37[2]

		if var3_37 <= var0_37 then
			return true
		elseif var4_37 == MusicCollectionConst.Still_Show_On_Lock then
			return false, true
		else
			return false, false
		end
	end
end

function var0_0.addPicIDToLikeList(arg0_38, arg1_38)
	if table.contains(arg0_38.galleryPicLikeIDList, arg1_38) then
		print("already exist picID:" .. arg1_38)
	else
		arg0_38.galleryPicLikeIDList[#arg0_38.galleryPicLikeIDList + 1] = arg1_38
	end
end

function var0_0.removePicIDFromLikeList(arg0_39, arg1_39)
	for iter0_39, iter1_39 in ipairs(arg0_39.galleryPicLikeIDList) do
		if iter1_39 == arg1_39 then
			table.remove(arg0_39.galleryPicLikeIDList, iter0_39)

			return
		end
	end

	print("no exist picID:" .. arg1_39)
end

function var0_0.isLikedByPicID(arg0_40, arg1_40)
	return table.contains(arg0_40.galleryPicLikeIDList, arg1_40)
end

function var0_0.addMusicIDToLikeList(arg0_41, arg1_41)
	if table.contains(arg0_41.musicLikeIDList, arg1_41) then
		print("already exist picID:" .. arg1_41)
	else
		arg0_41.musicLikeIDList[#arg0_41.musicLikeIDList + 1] = arg1_41
	end
end

function var0_0.removeMusicIDFromLikeList(arg0_42, arg1_42)
	for iter0_42, iter1_42 in ipairs(arg0_42.musicLikeIDList) do
		if iter1_42 == arg1_42 then
			table.remove(arg0_42.musicLikeIDList, iter0_42)

			return
		end
	end

	print("no exist musicID:" .. arg1_42)
end

function var0_0.isLikedByMusicID(arg0_43, arg1_43)
	return table.contains(arg0_43.musicLikeIDList, arg1_43)
end

function var0_0.isGalleryHaveNewRes(arg0_44)
	if PlayerPrefs.GetInt("galleryVersion", 0) < GalleryConst.Version then
		return true
	else
		return false
	end
end

function var0_0.isMusicHaveNewRes(arg0_45)
	if PlayerPrefs.GetInt("musicVersion", 0) < MusicCollectionConst.Version then
		return true
	else
		return false
	end
end

function var0_0.isMangaHaveNewRes(arg0_46)
	if PlayerPrefs.GetInt("mangaVersion", 0) < MangaConst.Version then
		return true
	else
		return false
	end
end

return var0_0
