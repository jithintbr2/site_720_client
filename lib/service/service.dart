import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:site720_client/model/aboutUsModel.dart';
import 'package:site720_client/model/addComplaintModel.dart';
import 'package:site720_client/model/changePasswordModel.dart';
import 'package:site720_client/model/client_details/client_by_id.dart';
import 'package:site720_client/model/client_details/deduction_work_model.dart';
import 'package:site720_client/model/client_details/drawings_model.dart';
import 'package:site720_client/model/client_details/extra_work.dart';
import 'package:site720_client/model/client_details/schedule_payment_model.dart';
import 'package:site720_client/model/client_details/stage_list_model.dart';
import 'package:site720_client/model/client_details/work_updation_model.dart';
import 'package:site720_client/model/client_details/gallery.dart';
import 'package:site720_client/model/client_details/get_icons.dart';
import 'package:site720_client/model/client_details/payment_list.dart';
import 'package:site720_client/model/client_details/phase_video_model.dart';
import 'package:site720_client/model/complaintListModel.dart';
import 'package:site720_client/model/contactUsModel.dart';
import 'package:site720_client/model/forceUpdateModel.dart';
import 'package:site720_client/model/homePageModel.dart';
import 'package:site720_client/model/loginModel.dart';
import 'package:site720_client/model/phoneNumberCheck.dart';
import 'package:site720_client/model/profilePageModel.dart';
import 'package:site720_client/model/projectDetailsModel.dart';
import 'package:site720_client/model/projectListModel.dart';
import 'package:site720_client/model/resetPasswordModel.dart';
import 'package:site720_client/model/sendOtpModel.dart';
import 'package:site720_client/model/serviceListModel.dart';
import 'package:site720_client/settings/config.dart';

import '../model/bhkFilterListModel.dart';
import '../model/quotationEnquiryModel.dart';
import '../model/villaProjectModel.dart';

class HttpService {
  static final Dio _dio = Dio();
  static Future forceUpdate() async {
    try {
      var result = await _dio.get("${Config.apiBaseUrl}force_updation_data");
      ForceUpdateModel model = ForceUpdateModel.fromJson(result.data);
      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future login(phone, password, deviceToken) async {
    var formData = FormData.fromMap({
      'phone': phone,
      'password': password,
      'deviceToken': deviceToken,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}login", data: formData);
      if (result.statusCode == 200) {
        LoginModel model = LoginModel.fromJson(result.data);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future changePassword(token, password) async {
    var formData = FormData.fromMap({
      'token': token,
      'password': password,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}resetPassword", data: formData);
      ChangePasswordModel model = ChangePasswordModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future addContactForm(
      name, phoneNumber, place, serviceId, message) async {
    var formData = FormData.fromMap({
      'name': name,
      'phone': phoneNumber,
      'place': place,
      'service_id': serviceId,
      'message': message,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}add_contact_form",
          data: formData);
      //log(params);

      ContactUsModel model = ContactUsModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future addQuotationForm(
      name, phoneNumber, planImage, dImage, message) async {
    var formData = FormData.fromMap({
      'name': name,
      'phone_number': phoneNumber,
      'plan_image': await MultipartFile.fromFile(planImage!),
      '3d_plan':
          dImage == null ? dImage : await MultipartFile.fromFile(dImage!),
      'message': message,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}postEnquiry", data: formData);
      //log(params);

      QuotationEnquiryModel model = QuotationEnquiryModel.fromJson(result.data);
      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientByID(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}getClientByID", data: formData);

      ClientByIdModel model = ClientByIdModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getGallery(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientPhasesImages",
          data: formData);
      //log(params);

      GalleryModel model = GalleryModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientPaymentDetails(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio
          .post("${Config.apiBaseUrl}getClientPaymentDetails", data: formData);
      //log(params);

      if (result.statusCode == 200) {
        PaymentListModel model = PaymentListModel.fromJson(result.data);
        return model;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future getClientScheduledPayment(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post(
          "${Config.apiBaseUrl}getClientScheduledPayment",
          data: formData);
      //log(params);

      SchedulePaymentModel model = SchedulePaymentModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getStageList(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientStages",
          data: formData);

      if (result.statusCode == 200) {
        StageListModel model = StageListModel.fromJson(result.data);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientDeductionWork(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientDeductionWork",
          data: formData);

      if (result.statusCode == 200) {
        DeductionWorkModel model = DeductionWorkModel.fromJson(result.data);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientPhasesVideo(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientPhasesVideo",
          data: formData);
      //log(params);

      PhaseVideoModel model = PhaseVideoModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getWorkStatus(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientWorkUpdates",
          data: formData);
      //log(params);

      ClientWorkStatusModel model = ClientWorkStatusModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientExtraWork(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientExtraWork",
          data: formData);

      ExtraWorkModel model = ExtraWorkModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientPackage(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post(
        "${Config.apiBaseUrl}getClientPackage",
        data: formData,
        options: Options(responseType: ResponseType.bytes),
      );
      //

      // PackageModel model = PackageModel.fromJson(result.data);

      return result;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future profile(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientDetails",
          data: formData);
      //log(params);

      ProfilePageModel model = ProfilePageModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientSiteDrawings(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientSiteDrawings",
          data: formData);
      //log(params);

      DrawingsModel model = DrawingsModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getIcons(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}getIcons", data: formData);
      //log(params);

      GetIconsModel model = GetIconsModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future complaintList(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}view_complaint", data: formData);
      //log(params);

      ComplaintListModel model = ComplaintListModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future addComplaint(token, complaint) async {
    log(token);
    var formData = FormData.fromMap({'token': token, 'complaint': complaint});
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}add_complaint", data: formData);
      //log(params);

      AddComplaintModel model = AddComplaintModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future dashboard() async {
    log('a');
    try {
      var result = await _dio.get("${Config.apiBaseUrl}home");

      HomePageModel model = HomePageModel.fromJson(result.data);
      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future projectList(currentPage, itemPerPage, bhk, minAmount, maxAmount,
      minSquareFeet, maxSquareFeet) async {
    var params = {
      "currentPage": currentPage,
      "itemPerPage": itemPerPage,
      "bhk": bhk,
      "minAmount": minAmount,
      "maxAmount": maxAmount,
      "minSquareFeet": minSquareFeet,
      "maxSquareFeet": maxSquareFeet
    };
    try {
      var result = await _dio.get("${Config.apiBaseUrl}newdashboard",
          queryParameters: params);

      ProjectListModel model = ProjectListModel.fromJson(result.data);
      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future projectDetails(projectId) async {
    var formData = FormData.fromMap({
      'project_id': projectId,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}projectDetails", data: formData);

      ProjectDetailsModel model = ProjectDetailsModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future aboutUs() async {
    try {
      var result = await _dio.get("${Config.apiBaseUrl}about_us");

      AboutUsModel model = AboutUsModel.fromJson(result.data);
      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future serviceList() async {
    log('a');
    try {
      var result = await _dio.get("${Config.apiBaseUrl}serviceList");

      ServiceListModel model = ServiceListModel.fromJson(result.data);
      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future phoneNumberCheck(phoneNumber) async {
    var formData = FormData.fromMap({
      'phone': phoneNumber,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}check_phone_number",
          data: formData);

      PhoneNumberCheck model = PhoneNumberCheck.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future sendOtp(phoneNumber, otp) async {
    var formData = FormData.fromMap({
      'phone': phoneNumber,
      'otp': otp,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}sendOTP", data: formData);

      SendOtpModel model = SendOtpModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future resetPassword(phoneNumber, password) async {
    var formData = FormData.fromMap({
      'phone': phoneNumber,
      'password': password,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}reset_password", data: formData);

      ResetPasswordModel model = ResetPasswordModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future bhkFilterList() async {
    try {
      var result = await _dio.get("${Config.apiBaseUrl}getCategory");

      BhkFilterListModel model = BhkFilterListModel.fromJson(result.data);
      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future villaProjectList() async {
    try {
      var result = await _dio.get("${Config.apiBaseUrl}villaProjects");

      VillaProjectModel model = VillaProjectModel.fromJson(result.data);
      return model;
    } catch (e) {
      log(e.toString());
    }
  }
}
