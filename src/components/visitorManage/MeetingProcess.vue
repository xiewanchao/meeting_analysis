<template>
  <div>
    <div class="ti">
      当前会议流程
    </div>
    <el-card class="box-card">
      <el-card style="margin-bottom: 10px;">
        <el-descriptions title="会议信息">
          <el-descriptions-item label="当前会议">{{ curmeeting }}</el-descriptions-item>
          <el-descriptions-item label="会议时间">{{ meetingtime }}</el-descriptions-item>
          <el-descriptions-item label="会议主持人">{{ meeting.hoster }}</el-descriptions-item>
          <el-descriptions-item label="会议号">{{ meeting.number }}</el-descriptions-item>
          <el-descriptions-item label="会议链接"><a :href="meeting.link">{{ meeting.link }}</a></el-descriptions-item>
        </el-descriptions>
        <el-button type="primary" @click="addProcess">增加议程</el-button>
      </el-card>

      <el-card style="margin-bottom: 10px;">
        <div class="card-ti">
          线下参会人员
        </div>
        <el-table :data="offlineParticipation" stripe class="accessRecord-table">
          <el-table-column prop="time" label="时长" align="center"></el-table-column>
          <el-table-column prop="topicName" label="分享主题" align="center"></el-table-column>
          <el-table-column prop="people" label="主讲人" align="center"></el-table-column>
          <el-table-column prop="role" label="角色" align="center"></el-table-column>
          <el-table-column prop="project" label="课题" align="center"></el-table-column>
          <el-table-column prop="experiment" label="实验分析" align="center">
            <template v-slot="scope">
              <i :class="getIconClass(scope.row.experiment)"></i>
            </template>
          </el-table-column>
          <el-table-column prop="algorithm" label="算法模型" align="center">
            <template v-slot="scope">
              <i :class="getIconClass(scope.row.algorithm)"></i>
            </template>
          </el-table-column>
          <el-table-column prop="paper" label="论文进展" align="center">
            <template v-slot="scope">
              <i :class="getIconClass(scope.row.paper)"></i>
            </template>
          </el-table-column>
          <el-table-column prop="nextweekplan" label="下周计划" align="center">
            <template v-slot="scope">
              <i :class="getIconClass(scope.row.nextweekplan)"></i>
            </template>
          </el-table-column>
          <el-table-column prop="completion" label="是否完成" align="center"></el-table-column>
        </el-table>
      </el-card>

      <el-card style="margin-bottom: 10px;">
        <div class="card-ti">
          线上参会人员
        </div>
        <el-table :data="onlineParticipation" stripe class="accessRecord-table">
          <el-table-column prop="time" label="时长" align="center"></el-table-column>
          <el-table-column prop="topicName" label="分享主题" align="center"></el-table-column>
          <el-table-column prop="people" label="主讲人" align="center"></el-table-column>
          <el-table-column prop="role" label="角色" align="center"></el-table-column>
          <el-table-column prop="project" label="课题" align="center"></el-table-column>
          <el-table-column prop="experiment" label="实验分析" align="center">
            <template v-slot="scope">
              <i :class="getIconClass(scope.row.experiment)"></i>
            </template>
          </el-table-column>
          <el-table-column prop="algorithm" label="算法模型" align="center">
            <template v-slot="scope">
              <i :class="getIconClass(scope.row.algorithm)"></i>
            </template>
          </el-table-column>
          <el-table-column prop="paper" label="论文进展" align="center">
            <template v-slot="scope">
              <i :class="getIconClass(scope.row.paper)"></i>
            </template>
          </el-table-column>
          <el-table-column prop="nextweekplan" label="下周计划" align="center">
            <template v-slot="scope">
              <i :class="getIconClass(scope.row.nextweekplan)"></i>
            </template>
          </el-table-column>
          <el-table-column prop="completion" label="是否完成" align="center"></el-table-column>
        </el-table>
      </el-card>

      <el-card style="margin-bottom: 10px;">
        <div class="card-ti">
          未参会人员
        </div>
        <el-table :data="unParticipation" stripe class="accessRecord-table">
          <el-table-column prop="time" label="时长" align="center"></el-table-column>
          <el-table-column prop="topicName" label="分享主题" align="center"></el-table-column>
          <el-table-column prop="people" label="主讲人" align="center"></el-table-column>
          <el-table-column prop="role" label="角色" align="center"></el-table-column>
          <el-table-column prop="project" label="课题" align="center"></el-table-column>
          <el-table-column prop="experiment" label="实验分析" align="center">
            <template v-slot="scope">
              <i :class="getIconClass(scope.row.experiment)"></i>
            </template>
          </el-table-column>
          <el-table-column prop="algorithm" label="算法模型" align="center">
            <template v-slot="scope">
              <i :class="getIconClass(scope.row.algorithm)"></i>
            </template>
          </el-table-column>
          <el-table-column prop="paper" label="论文进展" align="center">
            <template v-slot="scope">
              <i :class="getIconClass(scope.row.paper)"></i>
            </template>
          </el-table-column>
          <el-table-column prop="nextweekplan" label="下周计划" align="center">
            <template v-slot="scope">
              <i :class="getIconClass(scope.row.nextweekplan)"></i>
            </template>
          </el-table-column>
          <el-table-column prop="completion" label="是否完成" align="center"></el-table-column>
        </el-table>
      </el-card>

    </el-card>

  </div>
</template>

<script>
import axios from 'axios';
export default {
  data() {
    return {
      meeting: [],
      curmeeting: "",
      meetingtime: "",
      topicData: [],
      dialogVisible: false,
      onlineParticipation: [],
      offlineParticipation: [],
      unParticipation: [],
      timer: null
    };
  },
  created() {
    this.getMeetingData()
      .then(() => {
        this.getMeetingProcessData();
      })
      .catch(error => {
        console.error(error);
      });
  },
  mounted() {
    this.timer = setInterval(this.getMeetingProcessData, 5 * 1000); // 5分钟
  },
  beforeDestroy() {
    clearInterval(this.timer);
  },
  methods: {
    getIconClass(value) {
      if (value === null || value === undefined || value === '') {
        return "el-icon-close";
      } else {
        return "el-icon-check";
      }
    },
    closedialog() {
      this.getMeetingProcessData()
    },
    getMeetingData() {
      const path = '/api/getCurrentmeeting';
      return axios.post(path, { aaa: "hhhhhhh" })
        .then(res => {
          this.meeting = res.data.reslist[0];
          this.meetingtime = this.meeting.date;
          this.curmeeting = this.meeting.theme;
          sessionStorage.setItem(
            "meetingInfo",
            JSON.stringify({
              id: this.meeting.id,
              theme: this.meeting.theme,
              hoster: this.meeting.host,
              selectDay: this.meeting.selectDay,
              link: this.meeting.link,
              number: this.meeting.number
            })
          );
        });
    },
    getMeetingProcessData() {
      const path = '/api/getMeetingProcessData';
      return axios.post(path, { meetingid: this.meeting.id })
        .then(res => {
          this.topicData = res.data.reslist;
          this.onlineParticipation = this.topicData.filter(topic => topic.participation_mode?.trim().toLowerCase() === '线上参加');
          this.offlineParticipation = this.topicData.filter(topic => topic.participation_mode?.trim().toLowerCase() === '线下参加');
        });

    },
    addProcess() {
      this.$router.push({ name: 'newProcess' });
    }
  }
};
</script>

<style scoped>
.card-ti {
  color: #1a1a1a;
  font-size: 16px;
  font-weight: 500;
  line-height: 34px;
}

.thismeeting {

  margin: 1%;
  width: 280px;
}

.el-table {
  margin-bottom: 3%;
}

.ti {
  margin-left: 1%;
  margin-top: 1%;
  color: #1a1a1a;
  font-size: 24px;
  font-weight: 500;
  line-height: 34px;
}


.box-card {
  margin-left: 1%;
  margin-right: 3%;
  margin-top: 1%;
  border-radius: 8px;
}

.accessRecord-wrapper {
  padding: 20px;
  background-color: #f5f5f5;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.accessRecord-title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.accessRecord-header {
  font-size: 24px;
  font-weight: 600;
  color: #444;
  /* Adjusted the color to a deep gray */
  letter-spacing: 0.5px;
  /* Added some letter-spacing for better readability */
}

.inputs {
  display: flex;
  gap: 10px;
  /* or you can use margin-right on child elements if the browser doesn't support 'gap' */
}

.accessRecord-table {
  background-color: #fff;
}
</style>
