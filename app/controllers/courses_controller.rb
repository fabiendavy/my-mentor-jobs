class CoursesController < ApplicationController
  def create
    @request = Request.find(params[:request_id])
    @course = Course.new(course_params)
    @course.request = @request
    if @course.save
      export_courses_to_json
      redirect_to request_path(@request)
    else
      render 'requests/show'
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    export_courses_to_json
    redirect_to request_path(@course.request)
  end

  private

  def course_params
    params.require(:course).permit(:date, :length)
  end

  def export_courses_to_json
    data = JSON.parse(File.read('data.json'))
    data["courses"] = []
    Course.all.each_with_object([]) { |course| data["courses"] << { id: course["id"], date: course["date"], length: course["length"], request_id: course.request["id"] } }
    File.open('data.json', 'wb') { |file| file.write(JSON.generate(data)) }
  end
end
