<template>
  <div class="mod-config">
    <el-form :inline="true" :model="dataForm" @keyup.enter.native="getDataList()">
      <el-form-item>
        <el-input v-model="dataForm.key" placeholder="参数名" clearable></el-input>
      </el-form-item>
      <el-form-item>
        <el-button @click="getDataList()">查询</el-button>
        <el-button v-if="isAuth('pm:item:save')" type="primary" @click="addOrUpdateHandle()">新增</el-button>
        <el-button v-if="isAuth('pm:item:delete')" type="danger" @click="deleteHandle()" :disabled="dataListSelections.length <= 0">批量删除</el-button>
      </el-form-item>
    </el-form>
    <el-table
      :data="dataList"
      border
      v-loading="dataListLoading"
      @selection-change="selectionChangeHandle"
      style="width: 100%;">
      <el-table-column
        type="selection"
        header-align="center"
        align="center"
        width="50">
      </el-table-column>
      <el-table-column
        prop="itemInfoId"
        header-align="center"
        align="center"
        label="项目id">
      </el-table-column>
      <el-table-column
        prop="matchName"
        header-align="center"
        align="center"
        label="赛事名称">
      </el-table-column>
      <el-table-column
        prop="matchUnit"
        header-align="center"
        align="center"
        label="组赛单位">
      </el-table-column>
      <el-table-column
        prop="matchType"
        header-align="center"
        align="center"
        label="赛制">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.matchType === 0" size="small">单人赛</el-tag>
          <el-tag v-if="scope.row.matchType === 1" size="small">团体赛</el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="userName"
        header-align="center"
        align="center"
        label="项目负责人">
      </el-table-column>
      <el-table-column
        prop="matchStartTime"
        header-align="center"
        align="center"
        label="竞赛起始日期">
      </el-table-column>
      <el-table-column
        prop="matchEndTime"
        header-align="center"
        align="center"
        label="竞赛结束日期">
      </el-table-column>
      <el-table-column
        prop="matchMajor"
        header-align="center"
        align="center"
        label="专业">
      </el-table-column>
      <el-table-column
        prop="hostUnit"
        header-align="center"
        align="center"
        label="竞赛主办单位">
      </el-table-column>
      <el-table-column
        prop="undertakeUnit"
        header-align="center"
        align="center"
        label="竞赛承办单位">
      </el-table-column>
      <el-table-column
        prop="itemInfoTime"
        header-align="center"
        align="center"
        label="申请立项日期">
      </el-table-column>
      <!--<el-table-column-->
        <!--prop="matchSign"-->
        <!--header-align="center"-->
        <!--align="center"-->
        <!--label="论证组赛的目的和意义">-->
      <!--</el-table-column>-->
      <el-table-column
        prop="itemInfoStatus"
        header-align="center"
        align="center"
        label="审核状态">
        <template slot-scope="scope">
          <el-tag type="small" v-if="scope.row.itemInfoStatus === 0"><span>未提交</span></el-tag>
          <el-tag type="small" v-if="scope.row.itemInfoStatus === 1"><span>待审核</span></el-tag>
          <el-tag type="small" v-if="scope.row.itemInfoStatus === 2"><span>通过</span></el-tag>
          <el-tag type="small" v-if="scope.row.itemInfoStatus === 3"><span>未通过</span></el-tag>
        </template>
      </el-table-column>
      <!--<el-table-column-->
        <!--prop="itemInfoFinish"-->
        <!--header-align="center"-->
        <!--align="center"-->
        <!--label="是否已经结题">-->
      <!--</el-table-column>-->
      <!--<el-table-column-->
        <!--prop="itemInfoIsDel"-->
        <!--header-align="center"-->
        <!--align="center"-->
        <!--label="删除标识">-->
      <!--</el-table-column>-->
      <el-table-column
        fixed="right"
        header-align="center"
        align="center"
        width="150"
        label="操作">
        <template slot-scope="scope">
          <el-button type="text" size="small" v-if="scope.row.itemInfoStatus === 0" @click="submitHandle(scope.row.itemInfoId, 1)">提交</el-button>
          <el-button type="text" size="small" v-if="scope.row.itemInfoStatus === 0 || scope.row.itemInfoStatus === 3" @click="addOrUpdateHandle(scope.row.itemInfoId)">修改</el-button>
          <el-button type="text" size="small" v-if="scope.row.itemInfoStatus === 0 || scope.row.itemInfoStatus === 3" @click="deleteHandle(scope.row.itemInfoId)">删除</el-button>
          <el-button type="text" size="small" v-if="scope.row.itemInfoStatus === 3" @click="retreatListHandle(scope.row.itemInfoId)">回退意见</el-button>
          <el-button type="text" size="small" @click="detailHandle(scope.row.itemInfoId)">详情</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      @size-change="sizeChangeHandle"
      @current-change="currentChangeHandle"
      :current-page="pageIndex"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="pageSize"
      :total="totalPage"
      layout="total, sizes, prev, pager, next, jumper">
    </el-pagination>
    <!-- 弹窗, 新增 / 修改 -->
    <add-or-update v-if="addOrUpdateVisible" ref="addOrUpdate" @refreshDataList="getDataList"></add-or-update>
    <!--<retreat-add v-if="retreatAddVisible" ref="retreatAdd" @refreshDataList="getDataList"></retreat-add>-->
    <retreat-list v-if="retreatListVisible" ref="retreatList" @refreshDataList="getDataList"></retreat-list>
    <detail v-if="detailVisible" ref="detail" @refreshDataList="getDataList"></detail>
  </div>
</template>

<script>
  import AddOrUpdate from './pmiteminfo-add-or-update'
  // import RetreatAdd from './pmiteminforetreat-add-or-update'
  import RetreatList from './pmiteminforetreat-list'
  import Detail from './detail'
  export default {
    data () {
      return {
        dataForm: {
          key: ''
        },
        dataList: [],
        pageIndex: 1,
        pageSize: 10,
        totalPage: 0,
        dataListLoading: false,
        dataListSelections: [],
        addOrUpdateVisible: false,
        retreatListVisible: false,
        retreatAddVisible: false,
        detailVisible: false
      }
    },
    components: {
      AddOrUpdate,
      // RetreatAdd,
      RetreatList,
      Detail
    },
    activated () {
      this.getDataList()
    },
    methods: {
      // 获取数据列表
      getDataList () {
        this.dataListLoading = true
        this.$http({
          url: this.$http.adornUrl('/pm/item/list'),
          method: 'get',
          params: this.$http.adornParams({
            'page': this.pageIndex,
            'limit': this.pageSize,
            'userId': this.$store.state.user.id,
            'key': this.dataForm.key
          })
        }).then(({data}) => {
          if (data && data.code === 0) {
            this.dataList = data.page.list
            this.totalPage = data.page.totalCount
          } else {
            this.dataList = []
            this.totalPage = 0
          }
          this.dataListLoading = false
        })
      },
      // 每页数
      sizeChangeHandle (val) {
        this.pageSize = val
        this.pageIndex = 1
        this.getDataList()
      },
      // 当前页
      currentChangeHandle (val) {
        this.pageIndex = val
        this.getDataList()
      },
      // 多选
      selectionChangeHandle (val) {
        this.dataListSelections = val
      },
      // 新增 / 修改
      addOrUpdateHandle (id) {
        this.addOrUpdateVisible = true
        this.$nextTick(() => {
          this.$refs.addOrUpdate.init(id)
        })
      },
      // 回退
      retreatAddHandle (id) {
        this.retreatAddVisible = true
        this.$nextTick(() => {
          this.$refs.retreatAdd.init(id)
        })
      },
      // 查看回退意见
      retreatListHandle (id) {
        this.retreatListVisible = true
        this.$nextTick(() => {
          this.$refs.retreatList.init(id)
        })
      },
      // 详情
      detailHandle (id) {
        this.detailVisible = true
        this.$nextTick(() => {
          this.$refs.detail.init(id)
        })
      },
      // 审批
      submitHandle (id, status) {
        this.$confirm(`确定提交操作?`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$http({
            url: this.$http.adornUrl('/pm/item/apply'),
            method: 'post',
            params: this.$http.adornParams({
              'id': id,
              'status': status
            })
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.$message({
                message: '操作成功',
                type: 'success',
                duration: 1500,
                onClose: () => {
                  this.getDataList()
                }
              })
            } else {
              this.$message.error(data.msg)
            }
          })
        })
      },
      // 删除
      deleteHandle (id) {
        var ids = id ? [id] : this.dataListSelections.map(item => {
          return item.itemInfoId
        })
        this.$confirm(`确定对[id=${ids.join(',')}]进行[${id ? '删除' : '批量删除'}]操作?`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$http({
            url: this.$http.adornUrl('/pm/item/delete'),
            method: 'post',
            data: this.$http.adornData(ids, false)
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.$message({
                message: '操作成功',
                type: 'success',
                duration: 1500,
                onClose: () => {
                  this.getDataList()
                }
              })
            } else {
              this.$message.error(data.msg)
            }
          })
        })
      }
    }
  }
</script>
