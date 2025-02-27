local var0_0 = class("Dorm3dInsCharRoom", import(".Dorm3dInsRoom"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.groupId = arg0_1:GetConfig("character")[1]
	arg0_1.isCare = getProxy(Dorm3dChatProxy):GetChatCare(arg0_1.groupId) == 1
end

function var0_0.GetName(arg0_2)
	return ShipGroup.getDefaultShipNameByGroupID(arg0_2.groupId)
end

function var0_0.GetFurnitureNum(arg0_3)
	local var0_3 = getProxy(ApartmentProxy):getRoom(arg0_3.id)

	if not var0_3 then
		return 0
	end

	return #_.keys(var0_3:GetFurnitures())
end

function var0_0.GetGiftNum(arg0_4)
	local var0_4 = pg.dorm3d_gift.get_id_list_by_ship_group_id[arg0_4.groupId]
	local var1_4 = getProxy(ApartmentProxy)

	return _.reduce(var0_4, 0, function(arg0_5, arg1_5)
		return arg0_5 + var1_4:GetGiftShopCount(arg1_5)
	end)
end

function var0_0.GetLastVisit(arg0_6)
	local var0_6 = getProxy(ApartmentProxy):getApartment(arg0_6.groupId)
	local var1_6 = var0_6 and var0_6.visitTime or 0

	if var1_6 == 0 then
		return i18n("dorm3d_privatechat_no_visit_time")
	end

	local var2_6 = math.floor((pg.TimeMgr.GetInstance():GetServerTime() - var1_6) / 86400)

	return var2_6 == 0 and i18n("dorm3d_privatechat_visit_time_now") or i18n("dorm3d_privatechat_visit_time", var2_6)
end

function var0_0.GetFavorLevel(arg0_7)
	local var0_7 = getProxy(ApartmentProxy):getApartment(arg0_7.groupId)

	return var0_7 and var0_7.level or 0
end

function var0_0.GetCard(arg0_8)
	local var0_8 = Apartment.New({
		ship_group = arg0_8.groupId
	}):GetSkinModelID(arg0_8:GetConfig("tag"))

	return string.format("dorm3dselect/apartment_skin_%d", var0_8)
end

function var0_0.IsCare(arg0_9)
	return arg0_9.isCare
end

function var0_0.SetCare(arg0_10, arg1_10)
	arg0_10.isCare = arg1_10 == 1

	getProxy(Dorm3dChatProxy):SetChatCare(arg0_10.groupId, arg1_10)
end

function var0_0.ShouldTip(arg0_11)
	local var0_11 = arg0_11:GetInsContent()
	local var1_11 = arg0_11:GetChatContent()
	local var2_11 = arg0_11:GetChatContent()

	return var0_11 or var1_11 or var2_11
end

function var0_0.GetInsContent(arg0_12)
	if arg0_12:IsDownloaded() and getProxy(Dorm3dInsProxy):AnyInstagramShouldTip(arg0_12.groupId) then
		return true, i18n("dorm3d_privatechat_new_topics", arg0_12:GetConfig("room"))
	else
		return false, i18n("dorm3d_privatechat_nonew_topics")
	end
end

function var0_0.GetPhoneContent(arg0_13)
	if arg0_13:IsDownloaded() and getProxy(Dorm3dInsProxy):ShoudTipPhoneById(arg0_13.groupId) then
		return true, i18n("dorm3d_privatechat_new_calls")
	else
		return false, i18n("dorm3d_privatechat_nonew_calls")
	end
end

function var0_0.GetChatContent(arg0_14)
	if arg0_14:IsDownloaded() and getProxy(Dorm3dChatProxy):ShouldShowShipTip(arg0_14.groupId) then
		return true, i18n("dorm3d_privatechat_nonew_messages")
	else
		return false, i18n("dorm3d_privatechat_new_messages")
	end
end

return var0_0
