local var0 = class("SearchFriendCommand", pm.SimpleCommand)

var0.SEARCH_TYPE_LIST = 1
var0.SEARCH_TYPE_RESUME = 2
var0.SEARCH_TYPE_FRIEND = 3

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.type
	local var2 = var0.keyword

	var2 = var2 and string.gsub(var2, "^%s*(.-)%s*$", "%1")

	local var3
	local var4 = tonumber(var2) and 0 or 1

	if var1 == var0.SEARCH_TYPE_LIST then
		pg.ConnectionMgr.GetInstance():Send(50014, {
			type = 0
		}, 50015, function(arg0)
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.player_list) do
				table.insert(var0, Friend.New(iter1))
			end

			arg0:sendNotification(GAME.FRIEND_SEARCH_DONE, {
				type = var1,
				list = var0
			})
		end)
	elseif var1 == var0.SEARCH_TYPE_RESUME or var1 == var0.SEARCH_TYPE_FRIEND then
		pg.ConnectionMgr.GetInstance():Send(50001, {
			type = var4,
			keyword = tostring(var2)
		}, 50002, function(arg0)
			local var0 = {}

			if arg0.result == 0 then
				table.insert(var0, Friend.New(arg0.player))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("friend_searchFriend_noPlayer"))
			end

			arg0:sendNotification(GAME.FRIEND_SEARCH_DONE, {
				type = var1,
				list = var0
			})
		end)
	end
end

return var0
