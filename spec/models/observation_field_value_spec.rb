require File.dirname(__FILE__) + '/../spec_helper.rb'

describe ObservationFieldValue, "validation" do
  it "should work for numeric fields" do
    of = ObservationField.make(:datatype => "numeric")
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => "fop")
    }.should raise_error(ActiveRecord::RecordInvalid)
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => "12")
    }.should_not raise_error(ActiveRecord::RecordInvalid)
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => "12.3")
    }.should_not raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should work for location" do
    of = ObservationField.make(:datatype => "location")
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => "what")
    }.should raise_error(ActiveRecord::RecordInvalid)
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => "35 45")
    }.should raise_error(ActiveRecord::RecordInvalid)
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => "35,45")
    }.should_not raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should work for date" do
    of = ObservationField.make(:datatype => "date")
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => "what")
    }.should raise_error(ActiveRecord::RecordInvalid)
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => "2011-12-32")
    }.should_not raise_error(ActiveRecord::RecordInvalid)
  end
  it "should work for datetime" do
    of = ObservationField.make(:datatype => "datetime")
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => "what")
    }.should raise_error(ActiveRecord::RecordInvalid)
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => Time.now.iso8601)
    }.should_not raise_error(ActiveRecord::RecordInvalid)
  end
  it "should work for time" do
    of = ObservationField.make(:datatype => "time")
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => "what")
    }.should raise_error(ActiveRecord::RecordInvalid)
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => "44:23")
    }.should raise_error(ActiveRecord::RecordInvalid)
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => "04:23")
    }.should_not raise_error(ActiveRecord::RecordInvalid)
  end
  it "should pass for allowed values" do
    of = ObservationField.make(:datatype => "text", :allowed_values => "foo|bar")
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => "foo")
    }.should_not raise_error(ActiveRecord::RecordInvalid)
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => "bar")
    }.should_not raise_error(ActiveRecord::RecordInvalid)
  end
  it "should fail for disallowed values" do
    of = ObservationField.make(:datatype => "text", :allowed_values => "foo|bar")
    lambda {
      ObservationFieldValue.make(:observation_field => of, :value => "baz")
    }.should raise_error(ActiveRecord::RecordInvalid)
  end
end