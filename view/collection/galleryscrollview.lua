local var0_0 = class("GalleryScrollView")

var0_0.GalleryPicGroupName = "GALLERY_PIC"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.owner = arg2_1
	arg0_1.scrollPanel = arg1_1
	arg0_1.rootTF = arg1_1.parent
	arg0_1.isDisposed = false

	arg0_1:initUIRefs()
	arg0_1:initData()
	arg0_1:initScrollCallbacks()
end

function var0_0.initUIRefs(arg0_2)
	arg0_2.progressText = arg0_2.scrollPanel:Find("TextProgress")
	arg0_2.lScrollPageSC = GetComponent(arg0_2.scrollPanel, "LScrollPage")
	arg0_2.scrollListContainer = arg0_2.scrollPanel:Find("Content")
end

function var0_0.initData(arg0_3)
	arg0_3.resLoader = AutoLoader.New()
	arg0_3.cardTFList = {}
	arg0_3.curMiddleDataIndex = 1
end

function var0_0.dispose(arg0_4)
	arg0_4.isDisposed = true

	arg0_4.resLoader:Clear()
end

function var0_0.isDestroyed(arg0_5)
	return arg0_5.isDisposed or not arg0_5.owner or arg0_5.owner.exited
end

function var0_0.initScrollCallbacks(arg0_6)
	function arg0_6.lScrollPageSC.itemInitedCallback(arg0_7, arg1_7)
		local var0_7 = arg0_7 + 1

		arg0_6.cardTFList[var0_7] = arg1_7

		if arg0_6:getPicInfoForShowByIndex(var0_7) == false then
			arg0_6:updateEmptyCard(arg1_7)
		else
			arg0_6:updateCard(arg0_7, arg1_7)
		end
	end

	function arg0_6.lScrollPageSC.itemClickCallback(arg0_8, arg1_8)
		local var0_8 = arg0_8 + 1

		if arg0_6:getPicInfoForShowByIndex(var0_8) then
			arg0_6:openPicViewLayer(var0_8)
		end
	end

	function arg0_6.lScrollPageSC.itemPitchCallback(arg0_9, arg1_9)
		local var0_9 = arg0_9 + 1

		if arg0_6.curMiddleDataIndex ~= var0_9 then
			arg0_6.curMiddleDataIndex = var0_9
		end
	end

	function arg0_6.lScrollPageSC.itemRecycleCallback(arg0_10, arg1_10)
		local var0_10 = arg0_10 + 1

		arg0_6.cardTFList[var0_10] = nil
	end

	function arg0_6.lScrollPageSC.itemMoveCallback(arg0_11)
		local var0_11 = arg0_6.owner.picInfoListForShow

		if #var0_11 == 1 then
			arg0_6:updateProgressText(1, 1)
		else
			arg0_6:updateProgressText(math.clamp(math.round(arg0_11 * (#var0_11 - 1)) + 1, 1, #var0_11), #var0_11)
		end
	end
end

function var0_0.refresh(arg0_12, arg1_12)
	if arg0_12:isDestroyed() then
		return
	end

	arg1_12 = arg1_12 or {}
	arg0_12.cardTFList = {}

	arg0_12.resLoader:Clear()
	setActive(arg0_12.progressText, true)

	arg0_12.curMiddleDataIndex = math.clamp(arg0_12.curMiddleDataIndex, 1, #arg1_12)
	arg0_12.lScrollPageSC.DataCount = #arg1_12

	arg0_12.lScrollPageSC:Init(arg0_12.curMiddleDataIndex - 1)
end

function var0_0.resetMiddleDataIndex(arg0_13)
	arg0_13.curMiddleDataIndex = 1
end

function var0_0.openPicViewLayer(arg0_14, arg1_14)
	local var0_14 = arg0_14:getPicInfoForShowByIndex(arg1_14)

	if not var0_14 then
		return
	end

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = AppreciatePicViewMediator,
		viewComponent = AppreciatePicViewLayer,
		data = {
			isShowLikeBtn = true,
			curPicInfo = var0_14,
			picInfoList = arg0_14:getPicInfoListForShow(),
			onPicSwitch = function(arg0_15)
				arg0_14:moveToPicInfo(arg0_15)
			end
		},
		onRemoved = function()
			if arg0_14:isDestroyed() then
				return
			end

			for iter0_16, iter1_16 in pairs(arg0_14.cardTFList) do
				if iter1_16 then
					local var0_16 = arg0_14:getPicInfoForShowByIndex(iter0_16)

					arg0_14:updateCardUsedTag(var0_16, iter1_16)
				end
			end
		end
	}))
end

function var0_0.moveToPicInfo(arg0_17, arg1_17)
	if arg0_17:isDestroyed() or not arg1_17 then
		return
	end

	for iter0_17, iter1_17 in ipairs(arg0_17.owner.picInfoListForShow) do
		if iter1_17 and iter1_17.id == arg1_17.id and iter1_17.type == arg1_17.type then
			arg0_17.curMiddleDataIndex = iter0_17

			arg0_17.lScrollPageSC:MoveToItemID(iter0_17 - 1)

			return
		end
	end
end

function var0_0.updateProgressText(arg0_18, arg1_18, arg2_18)
	setText(arg0_18.progressText, arg1_18 .. "/" .. arg2_18)
end

function var0_0.updateCard(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg1_19 + 1
	local var1_19 = arg0_19:getPicInfoForShowByIndex(var0_19)
	local var2_19 = arg2_19:Find("SelectBtn")

	setActive(var2_19, false)

	local var3_19 = arg2_19:Find("BlackMask")

	setActive(var3_19, false)

	local var4_19 = arg2_19:Find("CardNum")
	local var5_19 = var4_19:Find("Text")

	setActive(var4_19, true)
	setText(var5_19, "#" .. var0_19)
	arg0_19:updateCardImg(var1_19, arg2_19)
	arg0_19:updateCardUsedTag(var1_19, arg2_19)
end

function var0_0.updateCardImg(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg2_20:Find("CardImg")
	local var1_20 = arg0_20:getPreviewPicPath(arg1_20)
	local var2_20 = GetFileName(var1_20)

	setActive(var0_20, true)
	arg0_20.resLoader:LoadSprite(var1_20, var2_20, var0_20, false)
end

function var0_0.updateCardUsedTag(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg2_21:Find("UsedTag")

	setActive(var0_21, arg0_21:isPicUsed(arg1_21))
end

function var0_0.updateEmptyCard(arg0_22, arg1_22)
	local var0_22

	for iter0_22, iter1_22 in ipairs(arg0_22.owner.picInfoListForShow) do
		if iter1_22 then
			var0_22 = iter1_22

			break
		end
	end

	if not var0_22 then
		return
	end

	local var1_22 = arg1_22:Find("SelectBtn")

	setActive(var1_22, false)

	local var2_22 = arg1_22:Find("BlackMask")

	setActive(var2_22, true)

	local var3_22 = arg1_22:Find("CardNum")

	setActive(var3_22, false)

	local var4_22 = arg1_22:Find("UsedTag")

	setActive(var4_22, false)
	arg0_22:updateCardImg(var0_22, arg1_22)
	arg0_22:updateEmptyCardDownloadState(arg1_22)
end

function var0_0.updateEmptyCardDownloadState(arg0_23, arg1_23)
	local var0_23 = arg1_23:Find("BlackMask")

	setActive(var0_23, true)

	local var1_23 = var0_23:Find("Update")
	local var2_23 = var1_23:Find("Btn")
	local var3_23 = var2_23:Find("Text")
	local var4_23 = var1_23:Find("Progress")
	local var5_23 = arg0_23.owner:isGalleryDownloading()

	setActive(var1_23, true)
	setActive(var2_23, not var5_23)
	setActive(var4_23, var5_23)

	if var5_23 then
		local var6_23, var7_23 = arg0_23.owner:getGalleryDownloadProgress()

		setText(var3_23, i18n("word_manga_updating", var6_23, var7_23))
	elseif arg0_23.owner:isGalleryDownloadFailed() then
		setText(var3_23, i18n("word_manga_updatefailure"))
	else
		setText(var3_23, i18n("word_manga_checktoupdate"))
	end

	onButton(arg0_23.owner, var2_23, function()
		arg0_23.owner:showDownloadMsgBox()
	end, SFX_PANEL)
end

function var0_0.updateEmptyCardDownloadStateList(arg0_25)
	if arg0_25:isDestroyed() then
		return
	end

	for iter0_25, iter1_25 in pairs(arg0_25.cardTFList) do
		if iter1_25 and arg0_25:getPicInfoForShowByIndex(iter0_25) == false then
			arg0_25:updateEmptyCardDownloadState(iter1_25)

			break
		end
	end
end

function var0_0.getPreviewPicPath(arg0_26, arg1_26)
	return GalleryConst.GetGalleryPreviewPicPathByID(arg1_26.id)
end

function var0_0.isPicUsed(arg0_27, arg1_27)
	return AppreciatePicConst.isUsedPicInfo(arg1_27)
end

function var0_0.getPicInfoListForShow(arg0_28)
	local var0_28 = {}

	for iter0_28, iter1_28 in ipairs(arg0_28.owner.picInfoListForShow) do
		if iter1_28 then
			table.insert(var0_28, iter1_28)
		end
	end

	return var0_28
end

function var0_0.getPicInfoForShowByIndex(arg0_29, arg1_29)
	return arg0_29.owner:getPicInfoForShowByIndex(arg1_29)
end

return var0_0
