local var0_0 = require("protobuf")

module("guild_pb")

local var1_0 = {}

CAPITAL_LOG = var0_0.Descriptor()
var1_0.CAPITAL_LOG_MEMBER_ID_FIELD = var0_0.FieldDescriptor()
var1_0.CAPITAL_LOG_NAME_FIELD = var0_0.FieldDescriptor()
var1_0.CAPITAL_LOG_EVENT_TYPE_FIELD = var0_0.FieldDescriptor()
var1_0.CAPITAL_LOG_EVENT_TARGET_FIELD = var0_0.FieldDescriptor()
var1_0.CAPITAL_LOG_TIME_FIELD = var0_0.FieldDescriptor()
WEEKLY_TASK = var0_0.Descriptor()
var1_0.WEEKLY_TASK_ID_FIELD = var0_0.FieldDescriptor()
var1_0.WEEKLY_TASK_PROGRESS_FIELD = var0_0.FieldDescriptor()
var1_0.WEEKLY_TASK_MONDAY_0CLOCK_FIELD = var0_0.FieldDescriptor()
GUILD_TECHNOLOGY = var0_0.Descriptor()
var1_0.GUILD_TECHNOLOGY_ID_FIELD = var0_0.FieldDescriptor()
var1_0.GUILD_TECHNOLOGY_STATE_FIELD = var0_0.FieldDescriptor()
var1_0.GUILD_TECHNOLOGY_PROGRESS_FIELD = var0_0.FieldDescriptor()
FLEET_INFO = var0_0.Descriptor()
var1_0.FLEET_INFO_ID_FIELD = var0_0.FieldDescriptor()
var1_0.FLEET_INFO_SHIP_LIST_FIELD = var0_0.FieldDescriptor()
var1_0.CAPITAL_LOG_MEMBER_ID_FIELD.name = "member_id"
var1_0.CAPITAL_LOG_MEMBER_ID_FIELD.full_name = "guild.capital_log.member_id"
var1_0.CAPITAL_LOG_MEMBER_ID_FIELD.number = 1
var1_0.CAPITAL_LOG_MEMBER_ID_FIELD.index = 0
var1_0.CAPITAL_LOG_MEMBER_ID_FIELD.label = 2
var1_0.CAPITAL_LOG_MEMBER_ID_FIELD.has_default_value = false
var1_0.CAPITAL_LOG_MEMBER_ID_FIELD.default_value = 0
var1_0.CAPITAL_LOG_MEMBER_ID_FIELD.type = 13
var1_0.CAPITAL_LOG_MEMBER_ID_FIELD.cpp_type = 3
var1_0.CAPITAL_LOG_NAME_FIELD.name = "name"
var1_0.CAPITAL_LOG_NAME_FIELD.full_name = "guild.capital_log.name"
var1_0.CAPITAL_LOG_NAME_FIELD.number = 2
var1_0.CAPITAL_LOG_NAME_FIELD.index = 1
var1_0.CAPITAL_LOG_NAME_FIELD.label = 2
var1_0.CAPITAL_LOG_NAME_FIELD.has_default_value = false
var1_0.CAPITAL_LOG_NAME_FIELD.default_value = ""
var1_0.CAPITAL_LOG_NAME_FIELD.type = 9
var1_0.CAPITAL_LOG_NAME_FIELD.cpp_type = 9
var1_0.CAPITAL_LOG_EVENT_TYPE_FIELD.name = "event_type"
var1_0.CAPITAL_LOG_EVENT_TYPE_FIELD.full_name = "guild.capital_log.event_type"
var1_0.CAPITAL_LOG_EVENT_TYPE_FIELD.number = 3
var1_0.CAPITAL_LOG_EVENT_TYPE_FIELD.index = 2
var1_0.CAPITAL_LOG_EVENT_TYPE_FIELD.label = 2
var1_0.CAPITAL_LOG_EVENT_TYPE_FIELD.has_default_value = false
var1_0.CAPITAL_LOG_EVENT_TYPE_FIELD.default_value = 0
var1_0.CAPITAL_LOG_EVENT_TYPE_FIELD.type = 13
var1_0.CAPITAL_LOG_EVENT_TYPE_FIELD.cpp_type = 3
var1_0.CAPITAL_LOG_EVENT_TARGET_FIELD.name = "event_target"
var1_0.CAPITAL_LOG_EVENT_TARGET_FIELD.full_name = "guild.capital_log.event_target"
var1_0.CAPITAL_LOG_EVENT_TARGET_FIELD.number = 4
var1_0.CAPITAL_LOG_EVENT_TARGET_FIELD.index = 3
var1_0.CAPITAL_LOG_EVENT_TARGET_FIELD.label = 3
var1_0.CAPITAL_LOG_EVENT_TARGET_FIELD.has_default_value = false
var1_0.CAPITAL_LOG_EVENT_TARGET_FIELD.default_value = {}
var1_0.CAPITAL_LOG_EVENT_TARGET_FIELD.type = 13
var1_0.CAPITAL_LOG_EVENT_TARGET_FIELD.cpp_type = 3
var1_0.CAPITAL_LOG_TIME_FIELD.name = "time"
var1_0.CAPITAL_LOG_TIME_FIELD.full_name = "guild.capital_log.time"
var1_0.CAPITAL_LOG_TIME_FIELD.number = 5
var1_0.CAPITAL_LOG_TIME_FIELD.index = 4
var1_0.CAPITAL_LOG_TIME_FIELD.label = 2
var1_0.CAPITAL_LOG_TIME_FIELD.has_default_value = false
var1_0.CAPITAL_LOG_TIME_FIELD.default_value = 0
var1_0.CAPITAL_LOG_TIME_FIELD.type = 13
var1_0.CAPITAL_LOG_TIME_FIELD.cpp_type = 3
CAPITAL_LOG.name = "capital_log"
CAPITAL_LOG.full_name = "guild.capital_log"
CAPITAL_LOG.nested_types = {}
CAPITAL_LOG.enum_types = {}
CAPITAL_LOG.fields = {
	var1_0.CAPITAL_LOG_MEMBER_ID_FIELD,
	var1_0.CAPITAL_LOG_NAME_FIELD,
	var1_0.CAPITAL_LOG_EVENT_TYPE_FIELD,
	var1_0.CAPITAL_LOG_EVENT_TARGET_FIELD,
	var1_0.CAPITAL_LOG_TIME_FIELD
}
CAPITAL_LOG.is_extendable = false
CAPITAL_LOG.extensions = {}
var1_0.WEEKLY_TASK_ID_FIELD.name = "id"
var1_0.WEEKLY_TASK_ID_FIELD.full_name = "guild.weekly_task.id"
var1_0.WEEKLY_TASK_ID_FIELD.number = 1
var1_0.WEEKLY_TASK_ID_FIELD.index = 0
var1_0.WEEKLY_TASK_ID_FIELD.label = 2
var1_0.WEEKLY_TASK_ID_FIELD.has_default_value = false
var1_0.WEEKLY_TASK_ID_FIELD.default_value = 0
var1_0.WEEKLY_TASK_ID_FIELD.type = 13
var1_0.WEEKLY_TASK_ID_FIELD.cpp_type = 3
var1_0.WEEKLY_TASK_PROGRESS_FIELD.name = "progress"
var1_0.WEEKLY_TASK_PROGRESS_FIELD.full_name = "guild.weekly_task.progress"
var1_0.WEEKLY_TASK_PROGRESS_FIELD.number = 2
var1_0.WEEKLY_TASK_PROGRESS_FIELD.index = 1
var1_0.WEEKLY_TASK_PROGRESS_FIELD.label = 2
var1_0.WEEKLY_TASK_PROGRESS_FIELD.has_default_value = false
var1_0.WEEKLY_TASK_PROGRESS_FIELD.default_value = 0
var1_0.WEEKLY_TASK_PROGRESS_FIELD.type = 13
var1_0.WEEKLY_TASK_PROGRESS_FIELD.cpp_type = 3
var1_0.WEEKLY_TASK_MONDAY_0CLOCK_FIELD.name = "monday_0clock"
var1_0.WEEKLY_TASK_MONDAY_0CLOCK_FIELD.full_name = "guild.weekly_task.monday_0clock"
var1_0.WEEKLY_TASK_MONDAY_0CLOCK_FIELD.number = 3
var1_0.WEEKLY_TASK_MONDAY_0CLOCK_FIELD.index = 2
var1_0.WEEKLY_TASK_MONDAY_0CLOCK_FIELD.label = 2
var1_0.WEEKLY_TASK_MONDAY_0CLOCK_FIELD.has_default_value = false
var1_0.WEEKLY_TASK_MONDAY_0CLOCK_FIELD.default_value = 0
var1_0.WEEKLY_TASK_MONDAY_0CLOCK_FIELD.type = 13
var1_0.WEEKLY_TASK_MONDAY_0CLOCK_FIELD.cpp_type = 3
WEEKLY_TASK.name = "weekly_task"
WEEKLY_TASK.full_name = "guild.weekly_task"
WEEKLY_TASK.nested_types = {}
WEEKLY_TASK.enum_types = {}
WEEKLY_TASK.fields = {
	var1_0.WEEKLY_TASK_ID_FIELD,
	var1_0.WEEKLY_TASK_PROGRESS_FIELD,
	var1_0.WEEKLY_TASK_MONDAY_0CLOCK_FIELD
}
WEEKLY_TASK.is_extendable = false
WEEKLY_TASK.extensions = {}
var1_0.GUILD_TECHNOLOGY_ID_FIELD.name = "id"
var1_0.GUILD_TECHNOLOGY_ID_FIELD.full_name = "guild.guild_technology.id"
var1_0.GUILD_TECHNOLOGY_ID_FIELD.number = 1
var1_0.GUILD_TECHNOLOGY_ID_FIELD.index = 0
var1_0.GUILD_TECHNOLOGY_ID_FIELD.label = 2
var1_0.GUILD_TECHNOLOGY_ID_FIELD.has_default_value = false
var1_0.GUILD_TECHNOLOGY_ID_FIELD.default_value = 0
var1_0.GUILD_TECHNOLOGY_ID_FIELD.type = 13
var1_0.GUILD_TECHNOLOGY_ID_FIELD.cpp_type = 3
var1_0.GUILD_TECHNOLOGY_STATE_FIELD.name = "state"
var1_0.GUILD_TECHNOLOGY_STATE_FIELD.full_name = "guild.guild_technology.state"
var1_0.GUILD_TECHNOLOGY_STATE_FIELD.number = 2
var1_0.GUILD_TECHNOLOGY_STATE_FIELD.index = 1
var1_0.GUILD_TECHNOLOGY_STATE_FIELD.label = 2
var1_0.GUILD_TECHNOLOGY_STATE_FIELD.has_default_value = false
var1_0.GUILD_TECHNOLOGY_STATE_FIELD.default_value = 0
var1_0.GUILD_TECHNOLOGY_STATE_FIELD.type = 13
var1_0.GUILD_TECHNOLOGY_STATE_FIELD.cpp_type = 3
var1_0.GUILD_TECHNOLOGY_PROGRESS_FIELD.name = "progress"
var1_0.GUILD_TECHNOLOGY_PROGRESS_FIELD.full_name = "guild.guild_technology.progress"
var1_0.GUILD_TECHNOLOGY_PROGRESS_FIELD.number = 3
var1_0.GUILD_TECHNOLOGY_PROGRESS_FIELD.index = 2
var1_0.GUILD_TECHNOLOGY_PROGRESS_FIELD.label = 2
var1_0.GUILD_TECHNOLOGY_PROGRESS_FIELD.has_default_value = false
var1_0.GUILD_TECHNOLOGY_PROGRESS_FIELD.default_value = 0
var1_0.GUILD_TECHNOLOGY_PROGRESS_FIELD.type = 13
var1_0.GUILD_TECHNOLOGY_PROGRESS_FIELD.cpp_type = 3
GUILD_TECHNOLOGY.name = "guild_technology"
GUILD_TECHNOLOGY.full_name = "guild.guild_technology"
GUILD_TECHNOLOGY.nested_types = {}
GUILD_TECHNOLOGY.enum_types = {}
GUILD_TECHNOLOGY.fields = {
	var1_0.GUILD_TECHNOLOGY_ID_FIELD,
	var1_0.GUILD_TECHNOLOGY_STATE_FIELD,
	var1_0.GUILD_TECHNOLOGY_PROGRESS_FIELD
}
GUILD_TECHNOLOGY.is_extendable = false
GUILD_TECHNOLOGY.extensions = {}
var1_0.FLEET_INFO_ID_FIELD.name = "id"
var1_0.FLEET_INFO_ID_FIELD.full_name = "guild.fleet_info.id"
var1_0.FLEET_INFO_ID_FIELD.number = 1
var1_0.FLEET_INFO_ID_FIELD.index = 0
var1_0.FLEET_INFO_ID_FIELD.label = 2
var1_0.FLEET_INFO_ID_FIELD.has_default_value = false
var1_0.FLEET_INFO_ID_FIELD.default_value = 0
var1_0.FLEET_INFO_ID_FIELD.type = 13
var1_0.FLEET_INFO_ID_FIELD.cpp_type = 3
var1_0.FLEET_INFO_SHIP_LIST_FIELD.name = "ship_list"
var1_0.FLEET_INFO_SHIP_LIST_FIELD.full_name = "guild.fleet_info.ship_list"
var1_0.FLEET_INFO_SHIP_LIST_FIELD.number = 2
var1_0.FLEET_INFO_SHIP_LIST_FIELD.index = 1
var1_0.FLEET_INFO_SHIP_LIST_FIELD.label = 3
var1_0.FLEET_INFO_SHIP_LIST_FIELD.has_default_value = false
var1_0.FLEET_INFO_SHIP_LIST_FIELD.default_value = {}
var1_0.FLEET_INFO_SHIP_LIST_FIELD.type = 13
var1_0.FLEET_INFO_SHIP_LIST_FIELD.cpp_type = 3
FLEET_INFO.name = "fleet_info"
FLEET_INFO.full_name = "guild.fleet_info"
FLEET_INFO.nested_types = {}
FLEET_INFO.enum_types = {}
FLEET_INFO.fields = {
	var1_0.FLEET_INFO_ID_FIELD,
	var1_0.FLEET_INFO_SHIP_LIST_FIELD
}
FLEET_INFO.is_extendable = false
FLEET_INFO.extensions = {}
capital_log = var0_0.Message(CAPITAL_LOG)
fleet_info = var0_0.Message(FLEET_INFO)
guild_technology = var0_0.Message(GUILD_TECHNOLOGY)
weekly_task = var0_0.Message(WEEKLY_TASK)
