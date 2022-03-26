class SkylarkProjects
  def self.get_project_name(project_name = 1)
    @project_name = project_name
  end

  def self.project_name
    @project_name
  end

  def self.choose_project(project_name)
    case project_name
    when '1'
      {
        projectname: 'hezuo',
        namespace_id: 1,
        appid: 'f4f34a327fb4e2d5e87e5622f8ebb4cc45c7a8212650ebf2b95314f5170f0418',
        appsecret: '7b99f2c7f85f148c57d9ed4cd1bdcd3d59a99a1666b0af6395f8fd1d22f2f001',
        host: 'https://gxhz.cdht.gov.cn'
      }
    when '2' #公园城市建设局
      {
        projectname: 'gycsjsj',
        namespace_id: 1,
        appid: '33fdb0275f999b651c1f3013968ffbe6e38f397cdd2a6a8707b733c86032df3d',
        appsecret: 'c4564c11100a793f984aae9b7d7643fcf41ada0b6feab1cc4a154fda4a1cc03f',
        host: 'https://gycs.cdht.gov.cn'
      }
    when '3'
      {
        projectname: 'zhonghe',
        namespace_id: 116,
        appid: '4468132f4fed4386d4c68ee86a1eea80e1a4e134fe84338e40be55ee01b768a3',
        appsecret: '3f47a6334c2fcaec29f789e26b8276d14869d8f03b6812ea2f1253e2a3e8eb50',
        host: 'https://szzh.cdht.gov.cn'
      }
    when '4'
      {
        projectname: 'shiyang',
        namespace_id: 1,
        appid: '2ec4b4a06e3ccf39a4ab392f1d6df0989f28553f8d939bb924d6bfc34664d266',
        appsecret: '23d96fae78dd57ff96900ae173e833a97580043d985a5fa7c0be27964ff26e71',
        host: 'https://gxsy.cdht.gov.cn'
      }
    when '5'
      {
        projectname: 'xiyuan',
        namespace_id: 1,
        appid: '4820622e63c0e276d28cd92dce4ac1db1ae3540543f95c8fe9b4d25344582e3f',
        appsecret: '7be4e6b6b60f66ed0230f9d3a2d75aba3f835b12533c144ed6ddf8db1bbb2b58',
        host: 'https://xyfw.cdht.gov.cn'
      }
    when 6
      {
        projectname: 'guixi',
        namespace_id: 1,
        appid: '7372dee4ff2e6b3876e3b386a336a9171444fba5d3a1e5ae3e23c91d92bb68c6',
        appsecret: '17c24c7d264b2e7b629b9399a69c8be8cc50fc3ea2b9cfd79e8a484aaab986ca',
        host: 'https://gxzh.cdht.gov.cn'
      }
    end
  end
end
