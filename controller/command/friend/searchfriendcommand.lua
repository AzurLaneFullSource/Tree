local var0_0 = class("SearchFriendCommand", pm.SimpleCommand)

var0_0.SEARCH_TYPE_LIST = 1
var0_0.SEARCH_TYPE_RESUME = 2
var0_0.SEARCH_TYPE_FRIEND = 3

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.keyword

	var2_1 = var2_1 and string.gsub(var2_1, "^%s*(.-)%s*$", "%1")

	local var3_1
	local var4_1 = tonumber(var2_1) and 0 or 1

	if var1_1 == var0_0.SEARCH_TYPE_LIST then
		pg.ConnectionMgr.GetInstance():Send(50014, {
			type = 0
		}, 50015, function(arg0_2)
			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.player_list) do
				table.insert(var0_2, Friend.New(iter1_2))
			end

			arg0_1:sendNotification(GAME.FRIEND_SEARCH_DONE, {
				type = var1_1,
				list = var0_2
			})
		end)
	elseif var1_1 == var0_0.SEARCH_TYPE_RESUME or var1_1 == var0_0.SEARCH_TYPE_FRIEND then
		pg.ConnectionMgr.GetInstance():Send(50001, {
			type = var4_1,
			keyword = tostring(var2_1)
		}, 50002, function(arg0_3)
			local var0_3 = {}

			if arg0_3.result == 0 then
				table.insert(var0_3, Friend.New(arg0_3.player))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("friend_searchFriend_noPlayer"))
			end

			arg0_1:sendNotification(GAME.FRIEND_SEARCH_DONE, {
				type = var1_1,
				list = var0_3
			})
		end)
	end
end

return var0_0
