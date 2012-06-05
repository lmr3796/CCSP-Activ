module CalendarHelper
    def act_cal_id(act_id)
        Activity.find(act_id)
    end
end
